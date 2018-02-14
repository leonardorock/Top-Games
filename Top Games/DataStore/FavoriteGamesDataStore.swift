//
//  FavoriteGamesDataStore.swift
//  Top Games
//
//  Created by Leonardo Oliveira on 2/11/18.
//  Copyright © 2018 Leonardo Oliveira. All rights reserved.
//

import CoreData

class FavoriteGamesDataStore {
    
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchFavoriteGames(success: @escaping ([Game]) -> Void, failure: @escaping (Error) -> Void, completion: @escaping () -> Void) {
        let request = NSFetchRequest<FavoriteGame>(entityName: "FavoriteGame")
        let asyncFetchRequest = NSAsynchronousFetchRequest<FavoriteGame>(fetchRequest: request) { asyncFetchResult in
            DispatchQueue.main.async {
                if let result = asyncFetchResult.finalResult {
                    let games = result.map { Game(favoriteGame: $0) }
                    success(games)
                } else if let error = asyncFetchResult.operationError {
                    failure(error)
                }
                completion()
            }
        }
        context.perform { [weak self] in
            do {
                try self?.context.execute(asyncFetchRequest)
            } catch {
                failure(error)
            }
            completion()
        }
    }
    
    func save(game: Game, success: () -> Void, failure: (Error) -> Void, completion: () -> Void) {
        let favoriteGame = FavoriteGame(context: context)
        favoriteGame.id = Int32(game.id ?? 0)
        favoriteGame.name = game.name
        favoriteGame.viewers = Int32(game.viewers ?? 0)
        favoriteGame.boxURI = game.boxURI
        do {
            try context.save()
            NotificationCenter.default.post(name: .favoriteGameAdded, object: game)
            success()
        } catch {
            failure(error)
        }
        completion()
    }
    
    func delete(game: Game, success: () -> Void, failure: (Error) -> Void, completion: () -> Void) {
        let request = NSFetchRequest<FavoriteGame>(entityName: "FavoriteGame")
        request.predicate = NSPredicate(format: "id = %d", game.id ?? 0)
        do {
            let results = try context.fetch(request)
            results.forEach { context.delete($0) }
            try context.save()
            NotificationCenter.default.post(name: .favoriteGameRemoved, object: game)
            success()
        } catch {
            failure(error)
        }
        completion()
    }
    
    func save(games: [Game], success: () -> Void, failure: (Error) -> Void, completion: () -> Void) {
        games.forEach { game in
            let favoriteGame = FavoriteGame(context: context)
            favoriteGame.id = Int32(game.id ?? 0)
            favoriteGame.name = game.name
            favoriteGame.viewers = Int32(game.viewers ?? 0)
            favoriteGame.boxURI = game.boxURI
        }
        do {
            try context.save()
            NotificationCenter.default.post(name: .favoriteGamesAdded, object: games)
            success()
        } catch {
            failure(error)
        }
        completion()
    }
    
}
