//
//  TopGamesPresenterTest.swift
//  Top GamesTests
//
//  Created by Leonardo Oliveira on 2/14/18.
//  Copyright © 2018 Leonardo Oliveira. All rights reserved.
//

import XCTest
@testable import Top_Games

class TopGamesPresenterTest: XCTestCase {
    
    var topGamesView: TopGamesViewMock!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        topGamesView = TopGamesViewMock()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitialGamesLoad() {
        let topGamesService = TopGamesServiceMock(expectedResult: .newData)
        let favoriteGamesDataStore = FavoriteGamesDataStoreMock(expectedResult: .newData, booleanExpectedResult: .success)
        let presenter = TopGamesPresenter(topGamesService: topGamesService, favoriteGameDataStore: favoriteGamesDataStore)
        presenter.delegate = topGamesView
        presenter.viewDidLoad()
        
        XCTAssertTrue(topGamesView.setLoadingHasBeenCalled)
        XCTAssertTrue(topGamesView.insertItemsHasBeenCalled)
    }
    
    func testInitialGamesLoadWithoutResult() {
        let topGamesService = TopGamesServiceMock(expectedResult: .noData)
        let favoriteGamesDataStore = FavoriteGamesDataStoreMock(expectedResult: .newData, booleanExpectedResult: .success)
        let presenter = TopGamesPresenter(topGamesService: topGamesService, favoriteGameDataStore: favoriteGamesDataStore)
        presenter.delegate = topGamesView
        presenter.viewDidLoad()
        
        XCTAssertTrue(topGamesView.setLoadingHasBeenCalled)
        XCTAssertTrue(topGamesView.insertItemsHasBeenCalled)
        XCTAssertTrue(topGamesView.setEmptyHasBeenCalled)
    }
    
    func testInitialGamesLoadFailed() {
        let topGamesService = TopGamesServiceMock(expectedResult: .error)
        let favoriteGamesDataStore = FavoriteGamesDataStoreMock(expectedResult: .newData, booleanExpectedResult: .success)
        let presenter = TopGamesPresenter(topGamesService: topGamesService, favoriteGameDataStore: favoriteGamesDataStore)
        presenter.delegate = topGamesView
        presenter.viewDidLoad()
        
        XCTAssertTrue(topGamesView.setLoadingHasBeenCalled)
        XCTAssertTrue(topGamesView.presentErrorHasBeenCalled)
    }
    
    func testAddingItemToFavorite() {
        let topGamesService = TopGamesServiceMock(expectedResult: .newData)
        let favoriteGamesDataStore = FavoriteGamesDataStoreMock(expectedResult: .noData, booleanExpectedResult: .success)
        let presenter = TopGamesPresenter(topGamesService: topGamesService, favoriteGameDataStore: favoriteGamesDataStore)
        presenter.delegate = topGamesView
        presenter.viewDidLoad()
        
        presenter.changeFavoriteStateForGame(at: 0)
        
        XCTAssertTrue(topGamesView.reloadItemHasBeenCalled)
        XCTAssertTrue(topGamesView.performAddedToFavoriteAnimationForGameHasBeenCalled)
    }
    
    func testRemovingItemToFavorite() {
        let topGamesService = TopGamesServiceMock(expectedResult: .newData)
        let favoriteGamesDataStore = FavoriteGamesDataStoreMock(expectedResult: .newData, booleanExpectedResult: .success)
        let presenter = TopGamesPresenter(topGamesService: topGamesService, favoriteGameDataStore: favoriteGamesDataStore)
        presenter.delegate = topGamesView
        presenter.viewDidLoad()
        
        presenter.changeFavoriteStateForGame(at: 0)
        
        XCTAssertTrue(topGamesView.reloadItemHasBeenCalled)
        XCTAssertFalse(topGamesView.performAddedToFavoriteAnimationForGameHasBeenCalled)
    }
    
    func testFailingChangingItemToFavoriteState() {
        let topGamesService = TopGamesServiceMock(expectedResult: .newData)
        let favoriteGamesDataStore = FavoriteGamesDataStoreMock(expectedResult: .noData, booleanExpectedResult: .failed)
        let presenter = TopGamesPresenter(topGamesService: topGamesService, favoriteGameDataStore: favoriteGamesDataStore)
        presenter.delegate = topGamesView
        presenter.viewDidLoad()
        
        presenter.changeFavoriteStateForGame(at: 0)
        
        XCTAssertTrue(topGamesView.presentErrorHasBeenCalled)
    }
    
    func testShowingSelectedGame() {
        let topGamesService = TopGamesServiceMock(expectedResult: .newData)
        let favoriteGamesDataStore = FavoriteGamesDataStoreMock(expectedResult: .noData, booleanExpectedResult: .failed)
        let presenter = TopGamesPresenter(topGamesService: topGamesService, favoriteGameDataStore: favoriteGamesDataStore)
        presenter.delegate = topGamesView
        presenter.viewDidLoad()
        
        presenter.showGameDetailForGame(at: 0)
        
        XCTAssertTrue(topGamesView.showGameDetailForGameHasBeenCalled)
    }
    
}
