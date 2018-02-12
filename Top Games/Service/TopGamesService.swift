//
//  TopGamesService.swift
//  Top Games
//
//  Created by Leonardo Oliveira on 2/10/18.
//  Copyright © 2018 Leonardo Oliveira. All rights reserved.
//

import URITemplate

class TopGamesService: Service {
    
    let endpoint: String = "games/top"
    let configuration: ServiceConfiguration = .default
    
    func fetchTopGames(offset: Int = 0, limit: Int = 20, success: @escaping ([Game]) -> Void, failure: @escaping (Error) -> Void, completion: @escaping () -> Void) {
        let urlRequest = request(parameters: ["offset": offset, "limit": limit])
        let task = configuration.session.dataTask(with: urlRequest) { (data, response, error) in
            self.configuration.session.finishTasksAndInvalidate()
            DispatchQueue.main.async {
                if let data = data, let root = try? self.configuration.decoder.decode(Root.self, from: data), let games = root.top?.map({ Game(result: $0) }) {
                    success(games)
                } else if let error = error {
                    failure(error)
                }
                completion()
            }
        }
        task.resume()
        
    }
    
}
