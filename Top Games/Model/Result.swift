//
//  Result.swift
//  Top Games
//
//  Created by Leonardo Oliveira on 2/10/18.
//  Copyright © 2018 Leonardo Oliveira. All rights reserved.
//

struct Root: Codable {
    let top: [Result]?
}

struct Result: Codable {
    
    let game: Game?
    let viewers: Int?
    
    struct Game: Codable {
        
        let id: Int?
        let name: String?
        let box: ImageResource?
        
        enum CodingKeys: String, CodingKey {
            case id = "_id",
            name,
            box
        }
        
    }
    
}

