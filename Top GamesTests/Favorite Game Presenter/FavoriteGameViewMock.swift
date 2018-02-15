//
//  FavoriteGameViewMock.swift
//  Top GamesTests
//
//  Created by Leonardo Oliveira on 2/14/18.
//  Copyright © 2018 Leonardo Oliveira. All rights reserved.
//

@testable import Top_Games

class FavoriteGameViewMock: FavoriteGameViewDelegate {
    
    var insertItemsHasBeenCalled = false
    var insertItemHasBeenCalled = false
    var setLoadingHasBeenCalled = false
    var setEmptyHasBeenCalled = false
    var presentErrorHasBeenCalled = false
    var reloadItemsHasBeenCalled = false
    var removeItemHasBeenCalled = false
    var showGameDetailForGameHasBeenCalled = false
    
    func setLoading(_ loading: Bool) {
        setLoadingHasBeenCalled = true
    }
    
    func setEmpty(_ empty: Bool) {
        setEmptyHasBeenCalled = true
    }
    
    func present(error: Error) {
        presentErrorHasBeenCalled = true
    }
    
    func reloadItems() {
        reloadItemsHasBeenCalled = true
    }
    
    func removeItem(at index: Int) {
        removeItemHasBeenCalled = true
    }
    
    func insertItem(at index: Int) {
        insertItemHasBeenCalled = true
    }
    
    func insertItems(in range: CountableRange<Int>) {
        insertItemsHasBeenCalled = true
    }
    
    func showGameDetailFor(game: GameDataView) {
        showGameDetailForGameHasBeenCalled = true
    }
    
    
}
