//
//  FavoriteGamesDataStore.swift
//  Top GamesTests
//
//  Created by Leonardo Oliveira on 2/14/18.
//  Copyright © 2018 Leonardo Oliveira. All rights reserved.
//


@testable import Top_Games

class FavoriteGamesDataStoreMock: FavoriteGamesDataStore {
    
    var expectedResult: ExpectedResult? = .error
    var booleanExpectedResult: BooleanExpectedResult? = .failed
    
    lazy var error: Error = FakeError.fake
    
    lazy var games: [Game] = {
        let game = Game(id: 1, name: "Pokémon", viewers: 1_000_000, boxURI: nil, favorite: true)
        return Array(repeating: game, count: 20)
    }()
    
    init(expectedResult: ExpectedResult? = nil, booleanExpectedResult: BooleanExpectedResult? = nil) {
        super.init()
        self.expectedResult = expectedResult
        self.booleanExpectedResult = booleanExpectedResult
    }
    
    override func fetchFavoriteGames(success: @escaping ([Game]) -> Void, failure: @escaping (Error) -> Void, completion: @escaping () -> Void) {
        
        guard let expectedResult = expectedResult else {
            fatalError("to call this method you must set the expectedResult first")
        }
        
        switch expectedResult {
        case .newData:
            success(games)
            break
        case .noData:
            success([])
            break
        case .error:
            failure(FakeError.fake)
            break
        }
        completion()
    }
    
    override func save(game: Game, success: () -> Void, failure: (Error) -> Void, completion: () -> Void) {
        handleBooleanExpectedResult(success: success, failure: failure, completion: completion)
    }
    
    override func delete(game: Game, success: () -> Void, failure: (Error) -> Void, completion: () -> Void) {
        handleBooleanExpectedResult(success: success, failure: failure, completion: completion)
    }
    
    override func save(games: [Game], success: () -> Void, failure: (Error) -> Void, completion: () -> Void) {
        handleBooleanExpectedResult(success: success, failure: failure, completion: completion)
    }
    
    private func handleBooleanExpectedResult(success: () -> Void, failure: (Error) -> Void, completion: () -> Void) {
        guard let booleanExpectedResult = booleanExpectedResult else {
            fatalError("to call this method you must set the booleanExpectedResult first")
        }
        switch booleanExpectedResult {
        case .success:
            success()
            break
        case .failed:
            failure(FakeError.fake)
            break
        }
        completion()
    }
    
}
