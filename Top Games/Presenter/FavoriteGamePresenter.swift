//
//  FavoriteGamePresenter.swift
//  Top Games
//
//  Created by Leonardo Oliveira on 2/11/18.
//  Copyright © 2018 Leonardo Oliveira. All rights reserved.
//

import Foundation

protocol FavoriteGameViewDelegate: class {
    
    func setLoading(_ loading: Bool)
    func setEmpty(_ empty: Bool)
    func present(error: Error)
    func reloadItems()
    func removeItem(at index: Int)
    func insertItem(at index: Int)
    func insertItems(in range: CountableRange<Int>)
    func showGameDetailFor(game: GameDataView)
    
}

protocol FavoriteGamePresenterDelegate {
    
    weak var delegate: FavoriteGameViewDelegate? { get set }
    
    var numberOfItems: Int { get }
    
    func viewWillAppear()
    func viewWillDisappear()
    func fetchFavoriteGames()
    func game(at index: Int) -> GameDataView
    func changeFavoriteStateForGame(at index: Int)
    func insert(games: [GameDataView], at index: Int)
    func showGameDetailForGame(at index: Int)
    
}

class FavoriteGamePresenter: FavoriteGamePresenterDelegate {
    
    weak var delegate: FavoriteGameViewDelegate?
    
    private var games: [Game] = [] {
        didSet {
            self.delegate?.setEmpty(games.isEmpty)
        }
    }
    private var favoriteGamesDataStore: FavoriteGamesDataStore
    private var isLoading: Bool = false {
        didSet {
            self.delegate?.setLoading(isLoading)
        }
    }
    var numberOfItems: Int {
        return games.count
    }
    
    init(favoriteGamesDataStore: FavoriteGamesDataStore) {
        self.favoriteGamesDataStore = favoriteGamesDataStore
    }
    
    func viewWillAppear() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func viewWillDisappear() {
        registerForFavoriteGameUpdated()
    }
    
    func fetchFavoriteGames() {
        self.isLoading = true
        favoriteGamesDataStore.fetchFavoriteGames(success: { [weak self] (games) in
            self?.games = games
            self?.delegate?.reloadItems()
        }, failure: { [weak self] (error) in
            self?.delegate?.present(error: error)
        }) { [weak self] in
            self?.isLoading = false
        }
    }
    
    func game(at index: Int) -> GameDataView {
        return GameDataView(model: games[index])
    }
    
    func changeFavoriteStateForGame(at index: Int) {
        favoriteGamesDataStore.delete(game: games[index], success: { [weak self] in
            self?.games.remove(at: index)
            self?.delegate?.removeItem(at: index)
        }, failure: { [weak self] (error) in
            self?.delegate?.present(error: error)
        }, completion: {})
    }
    
    func showGameDetailForGame(at index: Int) {
        delegate?.showGameDetailFor(game: GameDataView(model: games[index]))
    }
    
    func insert(games: [GameDataView], at index: Int) {
        let currentFavoriteGames = self.games.flatMap { $0.id }
        let favoriteGames = games.map { game -> Game in
            var favoriteGame = game.model
            favoriteGame.favorite = true
            return favoriteGame
        } .filter { !currentFavoriteGames.contains($0.id!) }
        if favoriteGames.isEmpty { return }
        favoriteGamesDataStore.save(games: favoriteGames, success: { [weak self] in
            self?.games.insert(contentsOf: favoriteGames, at: index)
            let range = index..<(index + favoriteGames.count)
            self?.delegate?.insertItems(in: range)
        }, failure: { [weak self] (error) in
            self?.delegate?.present(error: error)
        }) {
            
        }
    }
    
    private func registerForFavoriteGameUpdated() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(favoriteGameAdded(notification:)), name: .favoriteGameAdded, object: nil)
        notificationCenter.addObserver(self, selector: #selector(favoriteGameRemoved(notification:)), name: .favoriteGameRemoved, object: nil)
    }
    
    private func insert(game: Game) {
        var favoriteGame = game
        favoriteGame.favorite = true
        games.append(favoriteGame)
        delegate?.insertItem(at: games.count - 1)
    }
    
    private func remove(game: Game) {
        guard let index = games.index(where: { $0.id == game.id }) else { return }
        games.remove(at: index)
        delegate?.removeItem(at: index)
    }
    
    @objc private func favoriteGameAdded(notification: Notification) {
        guard let game = notification.object as? Game else { return }
        insert(game: game)
    }
    
    @objc private func favoriteGameRemoved(notification: Notification) {
        guard let game = notification.object as? Game else { return }
        remove(game: game)
    }
    
}
