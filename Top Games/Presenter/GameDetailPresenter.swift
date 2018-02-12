//
//  GameDetailPresenter.swift
//  Top Games
//
//  Created by Leonardo Oliveira on 2/12/18.
//  Copyright © 2018 Leonardo Oliveira. All rights reserved.
//

import Foundation

protocol GameDetailViewDelegate: class {
    
    func setup(with game: GameDataView)
    func updateFavoriteButtonState(to favorite: Bool)
    func present(error: Error)
    
}

protocol GameDetailPresenterDelegate {
    weak var delegate: GameDetailViewDelegate? { get set }
    
    func viewDidLoad(game: GameDataView)
    func changeFavoriteStateForGameButtonTapped()
}

class GameDetailPresenter: GameDetailPresenterDelegate {
    
    weak var delegate: GameDetailViewDelegate?
    
    private var game: Game!
    private var favoriteDataStore: FavoriteGamesDataStore
    
    init(favoriteDataStore: FavoriteGamesDataStore) {
        self.favoriteDataStore = favoriteDataStore
    }
    
    func viewDidLoad(game: GameDataView) {
        self.game = game.model
        delegate?.setup(with: game)
    }
    
    func changeFavoriteStateForGameButtonTapped() {
        if game.favorite {
            favoriteDataStore.delete(game: game, success: { [weak self] in
                self?.delegate?.updateFavoriteButtonState(to: false)
            }, failure: { [weak self] error in
                self?.delegate?.present(error: error)
            }, completion: {})
        } else {
            favoriteDataStore.save(game: game, success: { [weak self] in
                self?.delegate?.updateFavoriteButtonState(to: true)
            }, failure: { [weak self] error in
                self?.delegate?.present(error: error)
            }, completion: {})
        }
    }
    
}

