//
//  TopGamesServiceMock.swift
//  Top GamesTests
//
//  Created by Leonardo Oliveira on 2/14/18.
//  Copyright © 2018 Leonardo Oliveira. All rights reserved.
//

import Foundation
@testable import Top_Games

class TopGamesServiceMock: TopGamesService {
    
    let expectedResult: ExpectedResult
    
    lazy var error: Error = FakeError.fake
    
    lazy var games: [Game] = {
        let game = Game(id: 1, name: "Pokémon", viewers: 1_000_000, boxURI: nil, favorite: false)
        return Array(repeating: game, count: 20)
    }()
    
    init(expectedResult: ExpectedResult) {
        self.expectedResult = expectedResult
    }
    
    
    override func fetchTopGames(offset: Int, limit: Int, success: @escaping ([Game]) -> Void, failure: @escaping (Error) -> Void, completion: @escaping () -> Void) {
        
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
    
}
