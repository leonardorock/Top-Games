//
//  TodayViewController.swift
//  Top Games Widget
//
//  Created by Leonardo Oliveira on 2/14/18.
//  Copyright © 2018 Leonardo Oliveira. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDataSource, TopGamesWidgetViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var presenter: TopGamesWidgetPresenterDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = TopGamesWidgetPresenter(topGamesService: TopGamesService())
        presenter.delegate = self
        setupTableView()
        setupWidget()
    }
    
    func setupTableView() {
        tableView.register(cellType: GameTableViewCell.self)
    }
    
    func setupWidget() {
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        presenter.fetchNewData(completion: completionHandler)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if (activeDisplayMode == .expanded) {
            let height = GameTableViewCell.height * CGFloat(presenter.numberOfItems)
            self.preferredContentSize = CGSize(width: maxSize.width, height: height);
        } else if (activeDisplayMode == .compact) {
            self.preferredContentSize = maxSize;
        }
    }
    
    // MARK: - TopGamesWidgetViewDelegate
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func setEmpty(_ empty: Bool) {
        if empty {
            tableView.backgroundView = self.label(message: NSLocalizedString("No games found", comment: "No games found message"))
        } else {
            tableView.backgroundView = nil
        }
    }
    
    func present(error: Error) {
        tableView.backgroundView = self.label(message: error.localizedDescription)
    }
    
    func removeError() {
        tableView.backgroundView = nil
    }
    
    private func label(message: String) -> UILabel {
        let label = UILabel()
        label.text = message
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }
    
    // MARK: - table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: GameTableViewCell.self)
        cell.setup(with: presenter.game(at: indexPath.row))
        return cell
    }
    
    
    
}
