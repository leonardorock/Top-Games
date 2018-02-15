//
//  TopGamesCollectionViewController.swift
//  Top Games
//
//  Created by Leonardo Oliveira on 2/8/18.
//  Copyright © 2018 Leonardo Oliveira. All rights reserved.
//

import UIKit

class TopGamesCollectionViewController: UICollectionViewController, UICollectionViewDataSourcePrefetching, UISearchResultsUpdating, UISearchBarDelegate, UIViewControllerTransitioningDelegate, UICollectionViewDragDelegate, ContextualImageTransitionDelegate, GameCollectionViewCellDelegate, TopGamesViewDelegate {

    private var spaceBetweenCells: CGFloat = 0.0
    private var shouldInvalidateLayout = false
    
    private var presenter: TopGamesPresenterDelegate!
    private var animationController = ContextualImageTransitionAnimationController()
    private var indexPathForSelectedItem: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let context = CoreDataStack.shared.persistentContainer.viewContext
        presenter = TopGamesPresenter(topGamesService: TopGamesService(), favoriteGameDataStore: FavoriteGamesDataStore(context: context))
        presenter.delegate = self
        presenter.viewDidLoad()
        setupColletionView()
        setupSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.viewWillDisappear()
    }
    
    private func setupColletionView() {
        collectionView?.dragDelegate = self
        collectionView?.prefetchDataSource = self
        collectionView?.dragInteractionEnabled = true
        collectionView?.register(cellType: GameCollectionViewCell.self)
        collectionView?.collectionViewLayout = GamesCollectionViewFlowLayout()
        setupRefreshControl()
    }
    
    private func setupRefreshControl() {
        collectionView?.refreshControl = UIRefreshControl()
        collectionView?.refreshControl?.tintColor = .white
        collectionView?.refreshControl?.addTarget(self, action: #selector(refreshControlValueChanged(_:)), for: .valueChanged)
    }
    
    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.tintColor = #colorLiteral(red: 0.7803921569, green: 0.7058823529, blue: 0.8784313725, alpha: 1)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    // MARK: - Interface builder actions
    
    @objc func refreshControlValueChanged(_ sender: Any) {
        presenter.refreshControlValueChanged()
    }
    
    // MARK: - Top Games View Delegate
    
    func insertItems(in range: CountableRange<Int>) {
        collectionView?.insertItems(at: range.map({ IndexPath(row: $0, section: 0) }))
    }
    
    func setEmpty(_ empty: Bool, reason: EmptyReason) {
        if empty {
            let emptyStateView = EmptyStateView.loadFromNib()
            switch reason {
            case .searchResult(let query):
                emptyStateView.imageView?.image = #imageLiteral(resourceName: "search-icon")
                emptyStateView.titleLabel?.text = NSLocalizedString("No games found", comment: "No search results empty state title")
                emptyStateView.messageLabel?.text = String(format: NSLocalizedString("Sorry, we didn't find any games named \"%@\"", comment: "No search results empty state message"), query ?? "")
                break
            case .noResults:
                emptyStateView.imageView?.image = #imageLiteral(resourceName: "game-controller-outline-big")
                emptyStateView.titleLabel?.text = NSLocalizedString("No games found", comment: "No results empty state title")
                emptyStateView.messageLabel?.text = NSLocalizedString("Sorry, we didn't find any games", comment: "No results empty state message")
                break
            }
            collectionView?.backgroundView = emptyStateView
        } else {
            collectionView?.backgroundView = nil
        }
    }
    
    func setLoading(_ loading: Bool) {
        if loading {
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
            activityIndicator.startAnimating()
            let activityIndicatorItem = UIBarButtonItem(customView: activityIndicator)
            navigationItem.setRightBarButton(activityIndicatorItem, animated: true)
        } else {
            navigationItem.setRightBarButton(nil, animated: true)
            collectionView?.refreshControl?.endRefreshing()
        }
    }
    
    func present(error: Error) {
        let title = NSLocalizedString("Error", comment: "Error title message")
        let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    func reloadItems() {
        collectionView?.reloadData()
    }
    
    func reloadItem(at index: Int) {
        collectionView?.reloadItems(at: [IndexPath(row: index, section: 0)])
    }
    
    func showGameDetailFor(game: GameDataView) {
        performSegue(withIdentifier: "showGameDetail", sender: game)
    }
    
    func performAddedToFavoritesAnimationForGame(at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        
        let cell = collectionView?.cellForItem(at: indexPath)
        
        cell?.layer.removeAnimation(forKey: "addToFavorite")
        
        let positionAnimation = CABasicAnimation(keyPath: "position")
        positionAnimation.fromValue = cell?.center
        positionAnimation.toValue = CGPoint(x: view.frame.width * 0.75, y: collectionView!.contentOffset.y + view.frame.height)
        positionAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        positionAnimation.isRemovedOnCompletion = true
        positionAnimation.duration = 0.3
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1.0
        scaleAnimation.toValue = 0.1
        scaleAnimation.isRemovedOnCompletion = true
        scaleAnimation.duration = 0.3
        
        let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
        fadeInAnimation.fromValue = 0.0
        fadeInAnimation.toValue = 1.0
        fadeInAnimation.duration = 0.3
        fadeInAnimation.beginTime = 0.3
        fadeInAnimation.isRemovedOnCompletion = true
        
        let animations = CAAnimationGroup()
        animations.animations = [positionAnimation, scaleAnimation, fadeInAnimation]
        animations.duration = 0.6
        
        cell?.layer.add(animations, forKey: "addToFavorite")
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfItems
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: GameCollectionViewCell.self)
        cell.setup(with: presenter.game(at: indexPath.row))
        cell.delegate = self
        return cell
    }
    
    // MARK: - UICollectionViewDataSourcePrefetching
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: { $0.row >= presenter.numberOfItems - 1 }) {
            presenter.prefetchNextItems()
        }
    }

    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        indexPathForSelectedItem = indexPath
        presenter.showGameDetailForGame(at: indexPath.row)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { [weak self] context in
            self?.collectionView?.collectionViewLayout.invalidateLayout()
        })
    }
    
    // MARK: - UISearchResultsUpdater
    
    func updateSearchResults(for searchController: UISearchController) {
        presenter.filterGames(searchString: searchController.searchBar.text)
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        collectionView?.refreshControl?.isEnabled = false
        collectionView?.refreshControl?.removeFromSuperview()
        collectionView?.refreshControl = nil
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        setupRefreshControl()
    }
    
    // MARK: - Collection View Cell Delegate
    
    func favoriteButtonTapped(in cell: GameCollectionViewCell) {
        guard let indexPath = collectionView?.indexPath(for: cell) else { return }
        presenter.changeFavoriteStateForGame(at: indexPath.row)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGameDetail", let game = sender as? GameDataView {
            let destination = segue.destination as? GameDetailViewController
            destination?.game = game
            destination?.transitioningDelegate = self
        }
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let gameDetailViewController = presented as? ContextualImageTransitionDelegate
        animationController.setupTransition(from: self, to: gameDetailViewController)
        return animationController
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let gameDetailViewController = dismissed as? ContextualImageTransitionDelegate
        animationController.setupTransition(from: gameDetailViewController, to: self)
        return animationController
    }
    
    // MARK: - Contextual Image Transition Protocol
    
    var selectedImageView: UIImageView? {
        guard let indexPath = indexPathForSelectedItem, let collectionView = collectionView, let cell = collectionView.cellForItem(at: indexPath) as? GameCollectionViewCell else {
            return nil
        }
        if !collectionView.indexPathsForVisibleItems.contains(indexPath) {
            collectionView.scrollToItem(at: indexPath, at: .top, animated: false)
        }
        return cell.boxArtworkImageView
    }
    
    var imageViewFrameForContextualImageTransition: CGRect? {
        guard let frame = selectedImageView?.frame else { return CGRect(origin: view.center, size: .zero) }
        return selectedImageView?.convert(frame, to: view)
    }
    
    var imageForContextualImageTransition: UIImage? {
        return selectedImageView?.image
    }
    
    func transitionSetup() {
        selectedImageView?.alpha = 0.0
    }
    
    func transitionCleanUp() {
        selectedImageView?.alpha = 1.0
    }
    
    // MARK: - Collection view drag delegate
    
    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let dragPreviewParameters = UIDragPreviewParameters()
        dragPreviewParameters.backgroundColor = #colorLiteral(red: 0.4666666667, green: 0.4196078431, blue: 0.5411764706, alpha: 1)
        return dragPreviewParameters
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [dragItem(at: indexPath)]
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return [dragItem(at: indexPath)]
    }
    
    private func dragItem(at indexPath: IndexPath) -> UIDragItem {
        let game = presenter.game(at: indexPath.row)
        let itemProvider = game.itemProvider
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = game
        return dragItem
    }
}
