//
//  FavoriteGamePresenterTest.swift
//  Top GamesTests
//
//  Created by Leonardo Oliveira on 2/14/18.
//  Copyright © 2018 Leonardo Oliveira. All rights reserved.
//

import XCTest
@testable import Top_Games

class FavoriteGamePresenterTest: XCTestCase {
    
    var favoriteGameView: FavoriteGameViewMock!
    
    override func setUp() {
        super.setUp()
        favoriteGameView = FavoriteGameViewMock()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFavoriteLoad() {
        let favoriteGamesDataStore = FavoriteGamesDataStoreMock(expectedResult: .newData, booleanExpectedResult: .success)
        let presenter = FavoriteGamePresenter(favoriteGamesDataStore: favoriteGamesDataStore)
        presenter.delegate = favoriteGameView
        presenter.fetchFavoriteGames()
        
        XCTAssertTrue(favoriteGameView.setLoadingHasBeenCalled)
        XCTAssertTrue(favoriteGameView.reloadItemsHasBeenCalled)
    }
    
    func testFavoriteLoadFailed() {
        let favoriteGamesDataStore = FavoriteGamesDataStoreMock(expectedResult: .error, booleanExpectedResult: .success)
        let presenter = FavoriteGamePresenter(favoriteGamesDataStore: favoriteGamesDataStore)
        presenter.delegate = favoriteGameView
        presenter.fetchFavoriteGames()
        
        XCTAssertTrue(favoriteGameView.setLoadingHasBeenCalled)
        XCTAssertTrue(favoriteGameView.presentErrorHasBeenCalled)
    }
    
    func testRemovingGameFromFavoriteSuccess() {
        let favoriteGamesDataStore = FavoriteGamesDataStoreMock(expectedResult: .newData, booleanExpectedResult: .success)
        let presenter = FavoriteGamePresenter(favoriteGamesDataStore: favoriteGamesDataStore)
        presenter.delegate = favoriteGameView
        presenter.fetchFavoriteGames()
        
        presenter.changeFavoriteStateForGame(at: 0)
        
        XCTAssertTrue(favoriteGameView.removeItemHasBeenCalled)
    }
    
    func testRemovingGameFromFavoriteFailure() {
        let favoriteGamesDataStore = FavoriteGamesDataStoreMock(expectedResult: .newData, booleanExpectedResult: .failed)
        let presenter = FavoriteGamePresenter(favoriteGamesDataStore: favoriteGamesDataStore)
        presenter.delegate = favoriteGameView
        presenter.fetchFavoriteGames()
        
        presenter.changeFavoriteStateForGame(at: 0)
        
        XCTAssertFalse(favoriteGameView.removeItemHasBeenCalled)
        XCTAssertTrue(favoriteGameView.presentErrorHasBeenCalled)
    }
    
    func testShowingSelectedGame() {
        let favoriteGamesDataStore = FavoriteGamesDataStoreMock(expectedResult: .newData, booleanExpectedResult: .success)
        let presenter = FavoriteGamePresenter(favoriteGamesDataStore: favoriteGamesDataStore)
        presenter.delegate = favoriteGameView
        presenter.fetchFavoriteGames()
        
        presenter.showGameDetailForGame(at: 0)
        
        XCTAssertTrue(favoriteGameView.showGameDetailForGameHasBeenCalled)
    }
    
}
