//
//  GameCollectionViewCell.swift
//  Top Games
//
//  Created by Leonardo Oliveira on 2/8/18.
//  Copyright © 2018 Leonardo Oliveira. All rights reserved.
//

import Reusable

protocol GameCollectionViewCellDelegate: class {
    func favoriteButtonTapped(in cell: GameCollectionViewCell)
}

final class GameCollectionViewCell: UICollectionViewCell, NibReusable {

    static let size = CGSize(width: 136, height: 263)
    
    @IBOutlet weak var boxArtworkImageView: RemoteImageView!
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var numberOfViewersLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    weak var delegate: GameCollectionViewCellDelegate?
    
    func setup(with game: GameDataView) {
        boxArtworkImageView.setImage(uriTemplate: game.boxURITemplate, placeholderImage: #imageLiteral(resourceName: "social-twitch-outline"))
        gameTitleLabel.text = game.name
        numberOfViewersLabel.text = game.viewers
        if game.favorite {
            favoriteButton.setImage(#imageLiteral(resourceName: "heart-fill"), for: .normal)
        } else {
            favoriteButton.setImage(#imageLiteral(resourceName: "heart-outline"), for: .normal)
        }
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped(_:)), for: .touchUpInside)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        favoriteButton.removeTarget(self, action: nil, for: .allEvents)
        boxArtworkImageView.cancelRequest()
    }
    
    @objc func favoriteButtonTapped(_ sender: Any) {
        delegate?.favoriteButtonTapped(in: self)
    }
    
}
