//
//  FakeError.swift
//  Top GamesTests
//
//  Created by Leonardo Oliveira on 2/14/18.
//  Copyright © 2018 Leonardo Oliveira. All rights reserved.
//

import Foundation

enum FakeError: LocalizedError {
    
    case fake
    
    var errorDescription: String? {
        return "Fake error"
    }
    
}
