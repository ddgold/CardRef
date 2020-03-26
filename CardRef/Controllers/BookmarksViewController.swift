//
//  BookmarksViewController.swift
//  CardRef
//
//  Created by Doug Goldstein on 6/14/19.
//  Copyright © 2019 Doug Goldstein. All rights reserved.
//

import UIKit

/// Bookmarks view controller.
class BookmarksViewController: UITableViewController {
    //MARK: - Properties
    /// Whether or not there is an active database call.
    private var loadingData: Bool = false
    
    /// The list of bookmarked cards.
    var cards = [Card]()
    
    
    
    //MARK: - UIViewController
    /// Creates a new bookmarks view controller, sets plain style.
    init() {
        super.init(style: .grouped)
    }
    
    /// Decoder init not implemented.
    ///
    /// - Parameter aDecoder: The decoder.
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Setup the intial state of the bookmark view controller.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Bookmarks"
        
        tableView.register(CardTableViewCell.self, forCellReuseIdentifier: "bookmarkCell")
        tableView.register(LoadingTableViewCell.self, forHeaderFooterViewReuseIdentifier: "loadingCell")
        
        loadBookmarks()
        
        // Listen for theme changes
        Theme.subscribe(self, selector: #selector(updateTheme(_:)))
        updateTheme(nil)
    }
    
    
    
    //MARK: - UITableViewController
    /// Fixes the number of sections to 1.
    ///
    /// - Parameter tableView: The table view.
    /// - Returns: Tje number of sections.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// Determines the number of items in collection.
    ///
    /// - Parameters:
    ///   - tableView: The table view.
    ///   - section: The section number, must be 0.
    /// - Returns: The number of cells in section.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        assert(section == 0)
        
        return cards.count
    }
    
    /// Determines the height of the header for a section.
    ///
    /// - Parameters:
    ///   - tableView: The table view.
    ///   - section: The section number.
    /// - Returns: 0
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    /// Returns the height cell for a section.
    ///
    /// - Parameters:
    ///   - tableView: The table view.
    ///   - section: The section number.
    /// - Returns: A blank header cell.
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    /// Determines the height of the footer for a section.
    ///
    /// - Parameters:
    ///   - tableView: The table view.
    ///   - section: The section number.
    /// - Returns: 20
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if loadingData {
            return 50
        }
        else {
            return 0
        }
    }
    
    /// Returns the footer cell for a section.
    ///
    /// - Parameters:
    ///   - tableView: The table view.
    ///   - section: The section number.
    /// - Returns: A loading cell, or a blank footer cell.
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if loadingData {
            guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "loadingCell") as? LoadingTableViewCell else {
                fatalError("Unexpected cell type for loadingCell.")
            }
            return footer
        }
        else {
            return nil
        }
    }
    
    /// Dequeues a cell and updates it will new card.
    ///
    /// - Parameters:
    ///   - tableView: The table view.
    ///   - indexPath: The path to cell, section must be 0, and row less then number of cards.
    /// - Returns: The updated dequeued cell.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        assert(indexPath.section == 0)
        assert(indexPath.row < cards.count)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bookmarkCell", for: indexPath) as? CardTableViewCell else {
            fatalError("Unexpected cell type for bookmarkCell.")
        }
        cell.card = cards[indexPath.row]
        return cell
    }
    
    /// Pushes new card view controller with selected card.
    ///
    /// - Parameters:
    ///   - tableView: The table view.
    ///   - indexPath: The path to cell, section must be 0, and row less then number of cards.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        assert(indexPath.section == 0)
        assert(loadingData ? (indexPath.row == 0) : (indexPath.row < cards.count))
        
        if !loadingData {
            let cardViewController = CardViewController()
            cardViewController.card = cards[indexPath.row]
            navigationController?.pushViewController(cardViewController, animated: true)
        }
    }
    
    
    
    //MARK: - Public Functions
    /// Updates the view to the current theme.
    ///
    /// - Parameters:
    ///   - notification: Unused.
    @objc func updateTheme(_: Notification?) {
        self.navigationController?.navigationBar.barStyle = Theme.barStyle
        self.tabBarController?.tabBar.barStyle = Theme.barStyle
        self.tableView.backgroundColor = Theme.backgroundColor
    }
    
    
    
    //MARK: - Private Functions
    /// Load bookmarked cards from database
    private func loadBookmarks() {
        self.loadingData = true
        self.tableView.reloadData()
        
        let ids = ["3ee34158-867f-4685-8f2b-af9469b628c3", // Raging Goblin
                   "864ad989-19a6-4930-8efc-bbc077a18c32", // Bushi Tenderfoot
                   "c35c63c1-6344-4d8c-8f7d-cd253d12f9ae", // Down // Dirty
                   "09fd2d9c-1793-4beb-a3fb-7a869f660cd4", // Bonecrusher
                   "93b44747-9eb8-449b-a698-36a7a3045134", // Murder
                   "599c3c9f-dfb7-4357-9d9c-9a1a4616b103"] // Ashiok
        
        Datatank.cards(ids, completionHandler: { (cards) in
            DispatchQueue.main.async(execute: { () -> Void in
                self.cards = cards
                self.loadingData = false
                self.tableView.reloadData()
                print(Datatank.debugStatus())
            })
        }, errorHandler: { (responseError) in
            responseError.fatal()
        })
    }
}
