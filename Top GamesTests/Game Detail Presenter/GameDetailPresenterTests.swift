//
//  GameDetailPresenterTests.swift
//  Top GamesTests
//
//  Created by Leonardo Oliveira on 2/14/18.
//  Copyright © 2018 Leonardo Oliveira. All rights reserved.
//

import XCTest
@testable import Top_Games

class GameDetailPresenterTests: XCTestCase {
    
    var game: GameDataView!
    var gameDetailView: GameDetailViewMock!
    
    override func setUp() {
        super.setUp()
        gameDetailView = GameDetailViewMock()
        game = GameDataView(model: Game(id: 1, name: "Pokémon", viewers: 1243, boxURI: nil, favorite: true))
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGameSetup() {
        let favoriteGamesDataStore = FavoriteGamesDataStoreMock(expectedResult: .newData, booleanExpectedResult: .success)
        let presenter = GameDetailPresenter(favoriteDataStore: favoriteGamesDataStore)
        presenter.delegate = gameDetailView
        presenter.viewDidLoad(game: game)
        
        XCTAssertTrue(gameDetailView.setupWithGameHasBeenCalled)
    }
    
    func testChangeGameFavoriteStateSuccess() {
        let favoriteGamesDataStore = FavoriteGamesDataStoreMock(expectedResult: .newData, booleanExpectedResult: .success)
        let presenter = GameDetailPresenter(favoriteDataStore: favoriteGamesDataStore)
        presenter.delegate = gameDetailView
        presenter.viewDidLoad(game: game)
        
        presenter.changeFavoriteStateForGameButtonTapped()
        
        XCTAssertTrue(gameDetailView.updateFavoriteButtonStateToFavoriteHasBeenCalled)
    }
    
    func testChangeGameFavoriteStateFailure() {
        let favoriteGamesDataStore = FavoriteGamesDataStoreMock(expectedResult: .newData, booleanExpectedResult: .failed)
        let presenter = GameDetailPresenter(favoriteDataStore: favoriteGamesDataStore)
        presenter.delegate = gameDetailView
        presenter.viewDidLoad(game: game)
        
        presenter.changeFavoriteStateForGameButtonTapped()
        
        XCTAssertFalse(gameDetailView.updateFavoriteButtonStateToFavoriteHasBeenCalled)
        XCTAssertTrue(gameDetailView.presentErrorHasBeenCalled)
    }
    
    
}
