//
//  TopGamesWidgetPresenter.swift
//  Top Games Widget
//
//  Created by Leonardo Oliveira on 2/14/18.
//  Copyright © 2018 Leonardo Oliveira. All rights reserved.
//

import NotificationCenter

protocol TopGamesWidgetViewDelegate: class {
    
    func reloadData()
    func setEmpty(_ empty: Bool)
    func present(error: Error)
    func removeError()
    
}

protocol TopGamesWidgetPresenterDelegate {
    
    weak var delegate: TopGamesWidgetViewDelegate? { get set }
    
    var numberOfItems: Int { get }
    
    func fetchNewData(completion: (@escaping (NCUpdateResult) -> Void))
    func game(at index: Int) -> GameDataView
    
}

class TopGamesWidgetPresenter: TopGamesWidgetPresenterDelegate {
    
    weak var delegate: TopGamesWidgetViewDelegate?
    
    private var games: [Game] = []
    private let topGamesService: TopGamesService
    
    var numberOfItems: Int {
        return games.count
    }
    
    init(topGamesService: TopGamesService) {
        self.topGamesService = topGamesService
    }
    
    func fetchNewData(completion: @escaping ((NCUpdateResult) -> Void)) {
        topGamesService.fetchTopGames(limit: 3, success: { [weak self] games in
            self?.games = games
            if games.isEmpty {
                completion(.noData)
            } else {
                completion(.newData)
            }
            self?.delegate?.setEmpty(games.isEmpty)
            self?.delegate?.removeError()
        }, failure: { [weak self] (error) in
            completion(.failed)
            self?.delegate?.present(error: error)
        }) { [weak self] in
            self?.delegate?.reloadData()
            
        }
    }
    
    func game(at index: Int) -> GameDataView {
        return GameDataView(model: games[index])
    }
    
}
