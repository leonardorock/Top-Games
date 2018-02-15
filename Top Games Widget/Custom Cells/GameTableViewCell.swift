//
//  GameTableViewCell.swift
//  Top Games Widget
//
//  Created by Leonardo Oliveira on 2/14/18.
//  Copyright © 2018 Leonardo Oliveira. All rights reserved.
//

import UIKit
import Reusable

final class GameTableViewCell: UITableViewCell, NibReusable {
    
    static let height: CGFloat = 110.0

    @IBOutlet weak var boxArtworkImageView: RemoteImageView!
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var numberOfViewersLabel: UILabel!
    
    func setup(with game: GameDataView) {
        boxArtworkImageView.setImage(uriTemplate: game.boxURITemplate, placeholderImage: #imageLiteral(resourceName: "social-twitch-outline"))
        gameTitleLabel.text = game.name
        numberOfViewersLabel.text = game.viewers
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        boxArtworkImageView.cancelRequest()
    }
    
    
}
