//
//  TopGamesPresenter.swift
//  Top Games
//
//  Created by Leonardo Oliveira on 2/11/18.
//  Copyright © 2018 Leonardo Oliveira. All rights reserved.
//

import Foundation

protocol TopGamesViewDelegate: class {
    
    func insertItems(in range: CountableRange<Int>)
    func setLoading(_ loading: Bool)
    func present(error: Error)
    func reloadItems()
    func reloadItem(at index: Int)
    func showGameDetailFor(game: GameDataView)
    
}

protocol TopGamesPresenterDelegate {
    
    weak var delegate: TopGamesViewDelegate? { get set }

    var numberOfItems: Int { get }
    
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    func refreshControlValueChanged()
    func prefetchNextItems()
    func game(at index: Int) -> GameDataView
    func filterGames(searchString: String?)
    func changeFavoriteStateForGame(at index: Int)
    func showGameDetailForGame(at index: Int)
    
}

class TopGamesPresenter: TopGamesPresenterDelegate {
    
    weak var delegate: TopGamesViewDelegate?
    
    private var games: [Game] = []
    private var favoriteGamesIDs: Set<Int> = []
    private var filteredGames: [Game]? = nil
    private var isLoading: Bool = false {
        didSet {
            self.delegate?.setLoading(isLoading)
        }
    }
    private var isFiltered: Bool {
        return filteredGames != nil
    }
    private var shouldFetchItems: Bool {
        return !(isLoading || isFiltered)
    }
    
    var numberOfItems: Int {
        return filteredGames?.count ?? games.count
    }
    
    private var topGamesService: TopGamesService
    private var favoriteGameDataStore: FavoriteGamesDataStore
    
    init(topGamesService: TopGamesService, favoriteGameDataStore: FavoriteGamesDataStore) {
        self.topGamesService = topGamesService
        self.favoriteGameDataStore = favoriteGameDataStore
    }
    
    func viewDidLoad() {
        favoriteGameDataStore.fetchFavoriteGames(success: { [weak self] (games) in
            self?.favoriteGamesIDs = Set<Int>(games.flatMap { $0.id })
            self?.prefetchNextItems()
        }, failure: { [weak self] (error) in
            self?.delegate?.present(error: error)
        }) {}
    }
    
    func viewWillAppear() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func viewWillDisappear() {
        registerForFavoriteGameUpdated()
    }
    
    func refreshControlValueChanged() {
        self.games = []
        self.delegate?.reloadItems()
        fetchTopGames()
    }
    
    func prefetchNextItems() {
        fetchTopGames(offset: games.count)
    }
    
    func game(at index: Int) -> GameDataView {
        let game = gameModel(at: index)
        return GameDataView(model: game)
    }
    
    func filterGames(searchString: String?) {
        if let searchString = searchString, !searchString.isEmpty {
            filteredGames = games.filter { game in
                guard let name = game.name else { return false }
                return name.lowercased().contains(searchString.lowercased())
            }
        } else {
            filteredGames = nil
        }
        self.delegate?.reloadItems()
    }
    
    func changeFavoriteStateForGame(at index: Int) {
        let game = gameModel(at: index)
        if game.favorite {
            favoriteGameDataStore.delete(game: game, success: { [weak self] in
                self?.delete(favoriteGameID: game.id)
            }, failure: { [weak self] (error) in
                self?.delegate?.present(error: error)
            }, completion: { [weak self] in
                self?.delegate?.reloadItem(at: index)
            })
        } else {
            favoriteGameDataStore.save(game: game, success: { [weak self] in
                self?.add(favoriteGameID: game.id)
            }, failure: { [weak self] (error) in
                self?.delegate?.present(error: error)
            }, completion: { [weak self] in
                self?.delegate?.reloadItem(at: index)
            })
        }
    }
    
    func showGameDetailForGame(at index: Int) {
        delegate?.showGameDetailFor(game: GameDataView(model: gameModel(at: index)))
    }
    
    private func registerForFavoriteGameUpdated() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(favoriteGameAdded(notification:)), name: .favoriteGameAdded, object: nil)
        notificationCenter.addObserver(self, selector: #selector(favoriteGameRemoved(notification:)), name: .favoriteGameRemoved, object: nil)
        
    }
    
    @objc private func favoriteGameAdded(notification: Notification) {
        let game = notification.object as? Game
        add(favoriteGameID: game?.id)
    }
    
    @objc private func favoriteGameRemoved(notification: Notification) {
        let game = notification.object as? Game
        delete(favoriteGameID: game?.id)
    }
    
    private func add(favoriteGameID: Int?) {
        guard let id = favoriteGameID else { return }
        if favoriteGamesIDs.insert(id).inserted {
            reloadGame(id: id)
        }
    }
    
    private func delete(favoriteGameID: Int?) {
        guard let id = favoriteGameID, let index = favoriteGamesIDs.index(where: { $0 == id }) else { return }
        favoriteGamesIDs.remove(at: index)
        reloadGame(id: id)
    }
    
    private func reloadGame(id: Int) {
        guard let index = indexForGame(withID: id) else { return }
        self.delegate?.reloadItem(at: index)
    }
    
    private func indexForGame(withID id: Int) -> Int? {
        let criteria: (Game) -> Bool = { $0.id == id }
        guard let index = filteredGames?.index(where: criteria) ?? games.index(where: criteria) else { return nil }
        return index
    }
    
    private func gameModel(at index: Int) -> Game {
        var game = filteredGames?[index] ?? games[index]
        if let id = game.id {
            game.favorite = favoriteGamesIDs.contains(id)
        }
        return game
    }
    
    private func fetchTopGames(offset: Int = 0) {
        guard shouldFetchItems else { return }
        isLoading = true
        topGamesService.fetchTopGames(offset: offset, success: { [weak self] (games) in
            self?.insertGames(games: games)
        }, failure: { [weak self] (error) in
            self?.delegate?.present(error: error)
        }) { [weak self] in
            self?.isLoading = false
        }
    }
    
    private func insertGames(games: [Game]) {
        let newGamesRange = self.games.count..<(self.games.count + games.count)
        self.games.append(contentsOf: games)
        self.delegate?.insertItems(in: newGamesRange)
    }
    
}
