//
//  GameDataView.swift
//  Top Games
//
//  Created by Leonardo Oliveira on 2/10/18.
//  Copyright © 2018 Leonardo Oliveira. All rights reserved.
//

import URITemplate

struct GameDataView {
    
    let model: Game
    
    var name: String? {
        return model.name
    }
    
    var viewers: String? {
        guard let viewers = model.viewers else { return nil }
        return String(format: NSLocalizedString("%d viewers", comment: "number of viewers label"), viewers)
    }
    
    var boxURITemplate: URITemplate? {
        guard let boxURI = model.boxURI else { return nil }
        return URITemplate(template: boxURI)
    }
    
    var favorite: Bool {
        return model.favorite
    }
    
}
