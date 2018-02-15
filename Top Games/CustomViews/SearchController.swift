//
//  SearchController.swift
//  Top Games
//
//  Created by Leonardo Oliveira on 2/15/18.
//  Copyright © 2018 Leonardo Oliveira. All rights reserved.
//

import UIKit

class SearchController: UISearchController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isActive = false
    }

}
