//
//  GameExtension.swift
//  Top Games
//
//  Created by Leonardo Oliveira on 2/14/18.
//  Copyright © 2018 Leonardo Oliveira. All rights reserved.
//

extension Game {
    
    init(favoriteGame: FavoriteGame) {
        id = Int(favoriteGame.id)
        name = favoriteGame.name
        viewers = Int(favoriteGame.viewers)
        boxURI = favoriteGame.boxURI
        favorite = true
    }
    
}
