//
//  GameDetailViewController.swift
//  Top Games
//
//  Created by Leonardo Oliveira on 2/12/18.
//  Copyright © 2018 Leonardo Oliveira. All rights reserved.
//

import UIKit

class GameDetailViewController: UIViewController, GameDetailViewDelegate {
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var boxArtworkImageView: RemoteImageView!
    @IBOutlet weak var logoArtowrkImageView: RemoteImageView!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var viewersLabel: UILabel!

    private var presenter: GameDetailPresenterDelegate!
    
    var game: GameDataView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let context = CoreDataStack.shared.persistentContainer.viewContext
        presenter = GameDetailPresenter(favoriteDataStore: FavoriteGamesDataStore(context: context))
        presenter.delegate = self
        presenter.viewDidLoad(game: game)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Game detail view delegate
    
    func setup(with game: GameDataView) {
        boxArtworkImageView.setImage(uriTemplate: game.boxURITemplate, placeholderImage: #imageLiteral(resourceName: "social-twitch-outline"))
        logoArtowrkImageView.setImage(uriTemplate: game.logoURITemplate, placeholderImage: #imageLiteral(resourceName: "social-twitch-outline"))
        gameNameLabel.text = game.name
        viewersLabel.text = game.viewers
        updateFavoriteButtonState(to: game.favorite)
    }
    
    func updateFavoriteButtonState(to favorite: Bool) {
        let image = favorite ? #imageLiteral(resourceName: "heart-fill") : #imageLiteral(resourceName: "heart-outline")
        favoriteButton.setImage(image, for: .normal)
    }
    
    func present(error: Error) {
        let title = NSLocalizedString("Error", comment: "Error title message")
        let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    // MARK: - Interface builder actions
    
    @IBAction func dismissButtonTapped() {
        dismiss(animated: true)
    }
    
    @IBAction func changeFavoriteStateForGameButtonTapped(_ sender: Any) {
        presenter.changeFavoriteStateForGameButtonTapped()
    }

}
