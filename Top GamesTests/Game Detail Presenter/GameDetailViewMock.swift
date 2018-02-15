//
//  GameDetailViewMock.swift
//  Top GamesTests
//
//  Created by Leonardo Oliveira on 2/14/18.
//  Copyright © 2018 Leonardo Oliveira. All rights reserved.
//

@testable import Top_Games

class GameDetailViewMock: GameDetailViewDelegate {
    
    var setupWithGameHasBeenCalled = false
    var updateFavoriteButtonStateToFavoriteHasBeenCalled = false
    var presentErrorHasBeenCalled = false
    
    func setup(with game: GameDataView) {
        setupWithGameHasBeenCalled = true
    }
    
    func updateFavoriteButtonState(to favorite: Bool) {
        updateFavoriteButtonStateToFavoriteHasBeenCalled = true
    }
    
    func present(error: Error) {
        presentErrorHasBeenCalled = true
    }
    
}
