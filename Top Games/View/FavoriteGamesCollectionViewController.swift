//
//  FavoriteGamesCollectionViewController.swift
//  Top Games
//
//  Created by Leonardo Oliveira on 2/11/18.
//  Copyright © 2018 Leonardo Oliveira. All rights reserved.
//

import UIKit

class FavoriteGamesCollectionViewController: UICollectionViewController, GameCollectionViewCellDelegate, FavoriteGameViewDelegate {
    
    private var presenter: FavoriteGamePresenterDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let context = CoreDataStack.shared.persistentContainer.viewContext
        presenter = FavoriteGamePresenter(favoriteGamesDataStore: FavoriteGamesDataStore(context: context))
        presenter.delegate = self
        presenter.fetchFavoriteGames()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.viewWillDisappear()
    }
    
    private func setupCollectionView() {
        collectionView?.register(cellType: GameCollectionViewCell.self)
        collectionView?.collectionViewLayout = GamesCollectionViewFlowLayout()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { [weak self] context in
            self?.collectionView?.collectionViewLayout.invalidateLayout()
        })
    }
    
    // MARK: - Favorite game view delegate
    
    func setLoading(_ loading: Bool) {
        if loading {
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
            activityIndicator.startAnimating()
            let activityIndicatorItem = UIBarButtonItem(customView: activityIndicator)
            navigationItem.setRightBarButton(activityIndicatorItem, animated: true)
        } else {
            navigationItem.setRightBarButton(nil, animated: true)
        }
    }
    
    func setEmpty(_ empty: Bool) {
        
    }
    
    func present(error: Error) {
        let title = NSLocalizedString("Error", comment: "Error title")
        let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    func reloadItems() {
        collectionView?.reloadData()
    }
    
    func removeItem(at index: Int) {
        collectionView?.deleteItems(at: [IndexPath(row: index, section: 0)])
    }
    
    func insertItem(at index: Int) {
        collectionView?.insertItems(at: [IndexPath(row: index, section: 0)])
    }
    
    func showGameDetailFor(game: GameDataView) {
        performSegue(withIdentifier: "showGameDetail", sender: game)
    }
    
    // MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfItems
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: GameCollectionViewCell.self)
        cell.setup(with: presenter.game(at: indexPath.row))
        cell.delegate = self
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.showGameDetailForGame(at: indexPath.row)
    }

    // MARK: - Game Collection view cell
    
    func favoriteButtonTapped(in cell: GameCollectionViewCell) {
        guard let indexPath = collectionView?.indexPath(for: cell) else { return }
        presenter.changeFavoriteStateForGame(at: indexPath.row)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGameDetail", let game = sender as? GameDataView {
            let destination = segue.destination as? GameDetailViewController
            destination?.game = game
        }
    }
    
}