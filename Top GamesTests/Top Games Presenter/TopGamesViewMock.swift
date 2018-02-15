//
//  TopGamesViewMock.swift
//  Top GamesTests
//
//  Created by Leonardo Oliveira on 2/14/18.
//  Copyright © 2018 Leonardo Oliveira. All rights reserved.
//

@testable import Top_Games

class TopGamesViewMock: TopGamesViewDelegate {
    
    var insertItemsHasBeenCalled = false
    var setLoadingHasBeenCalled = false
    var setEmptyHasBeenCalled = false
    var presentErrorHasBeenCalled = false
    var reloadItemsHasBeenCalled = false
    var reloadItemHasBeenCalled = false
    var showGameDetailForGameHasBeenCalled = false
    var performAddedToFavoriteAnimationForGameHasBeenCalled = false
    
    func insertItems(in range: CountableRange<Int>) {
        insertItemsHasBeenCalled = true
    }
    
    func setLoading(_ loading: Bool) {
        setLoadingHasBeenCalled = true
    }
    
    func setEmpty(_ empty: Bool, reason: EmptyReason) {
        setEmptyHasBeenCalled = true
    }
    
    func present(error: Error) {
        presentErrorHasBeenCalled = true
    }
    
    func reloadItems() {
        reloadItemsHasBeenCalled = true
    }
    
    func reloadItem(at index: Int) {
        reloadItemHasBeenCalled = true
    }
    
    func showGameDetailFor(game: GameDataView) {
        showGameDetailForGameHasBeenCalled = true
    }
    
    func performAddedToFavoritesAnimationForGame(at index: Int) {
        performAddedToFavoriteAnimationForGameHasBeenCalled = true
    }
    
    
}
