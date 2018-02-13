//
//  Game.swift
//  Top Games
//
//  Created by Leonardo Oliveira on 2/10/18.
//  Copyright © 2018 Leonardo Oliveira. All rights reserved.
//

import Foundation
import URITemplate

struct Game {
    
    let id: Int?
    let name: String?
    let viewers: Int?
    let boxURI: String?
    var favorite: Bool
    
}

extension Game {
    
    init(result: Result) {
        id = result.game?.id
        name = result.game?.name
        viewers = result.viewers
        boxURI = result.game?.box?.template
        favorite = false
    }
    
    init(favoriteGame: FavoriteGame) {
        id = Int(favoriteGame.id)
        name = favoriteGame.name
        viewers = Int(favoriteGame.viewers)
        boxURI = favoriteGame.boxURI
        favorite = true
    }
    
}
