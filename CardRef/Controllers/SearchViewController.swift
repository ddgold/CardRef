//
//  SearchViewController.swift
//  CardRef
//
//  Created by Doug Goldstein on 6/16/19.
//  Copyright © 2019 Doug Goldstein. All rights reserved.
//

import UIKit

/// Search view controller.
class SearchViewController: UITableViewController, UISearchBarDelegate {
    //MARK: - Properties
    /// The current search object.
    private var search: Search?
    /// A List object from database.
    private var result: List<Card>?
    /// An RequestError object from database.
    private var error: RequestError?
    
    /// Whether or not there is an active database call.
    private var loadingData: Bool = false
    
    /// The list of cards loaded for current search.
    var cards = [Card]()
    
    
    
    //MARK: - UIViewController
    /// Creates a new search view controller, sets plain style.
    init() {
        super.init(style: .plain)
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
        
        // Setup search bar as navivation bar's title view
        let searchBar = UISearchBar()
        searchBar.autocapitalizationType = .none
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        tableView.backgroundView?.backgroundColor = .white
        
        tableView.register(CardTableViewCell.self, forCellReuseIdentifier: "searchCell")
        tableView.register(LoadingTableViewCell.self, forCellReuseIdentifier: "loadingCell")
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
    /// - Returns: The number of cells in section, plus the loading cell, if needed.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        assert(section == 0)
        
        return cards.count + ((loadingData || (result?.hasMore ?? false)) ? 1 : 0)
    }
    
    /// Dequeues a cell and updates it will new card.
    ///
    /// - Parameters:
    ///   - tableView: The table view.
    ///   - indexPath: The path to cell, section must be 0, and row less then number of cards.
    /// - Returns: The updated dequeued cell.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        assert(indexPath.row < cards.count + 1)
        if (indexPath.item < cards.count) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as? CardTableViewCell else {
                fatalError("Unexpected cell type for seachCell.")
            }
            cell.card = cards[indexPath.row]
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as? LoadingTableViewCell else {
                fatalError("Unexpected cell type for loadingCell.")
            }
            loadMoreCards()
            return cell
        }
    }
    
    /// Pushes new card view controller with selected card.
    ///
    /// - Parameters:
    ///   - tableView: The table view.
    ///   - indexPath: The path to cell, section must be 0, and row less then number of cards.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if (indexPath.item < cards.count) {
            let cardViewController = CardViewController()
            cardViewController.card = cards[indexPath.row]
            navigationController?.pushViewController(cardViewController, animated: true)
        }
    }

    
    
    //MARK: - UISearchBarDelegate
    /// Shows cancel button and hides right bar buttons.
    ///
    /// - Parameter searchBar: The search bar.
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        searchBar.showsCancelButton = true
    }
    
    /// Hides cancel button and shows right bar buttons.
    ///
    /// - Parameter searchBar: The search bar.
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar)
    {
        searchBar.showsCancelButton = false
    }
    
    /// Reverts search bar text, and ends editing.
    ///
    /// - Parameter searchBar: The search bar.
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.text = search?.query ?? nil
        searchBar.endEditing(false)
    }
    
    /// Runs new search, and ends editing.
    ///
    /// - Parameter searchBar: The search bar.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        search = Search(query: searchBar.text ?? "")
        searchBar.endEditing(false)
        
        searchForCards()
    }
    
    
    
    //MARK: - Private Functions
    /// Runs new search for cards from database . Does nothing if already loading data.
    private func searchForCards()
    {
        // Only allow one outstanding database call at once
        if loadingData
        {
            return
        }
        
        debugPrint("searching... \(search!.query)")
        
        self.result = nil
        self.error = nil
        self.cards = []
        
        self.loadingData = true
        tableView.reloadData()
        
        Datatank.search(search!, resultHandler: resultHandler, errorHandler: errorHandler)
    }
    
    /// Loads next page of cards of previous search from database. Does nothing if already loading data.
    private func loadMoreCards()
    {
        // Only allow one outstanding database call at once
        if loadingData
        {
            return
        }
        
        debugPrint("load more data...")
        
        self.loadingData = true
        
        Datatank.nextPage(result!, resultHandler: resultHandler, errorHandler: errorHandler)
    }
    
    /// Handles database results from new search or loading more cards.
    ///
    /// - Parameters:
    ///     - result: The result object from database.
    private func resultHandler(result: List<Card>) -> Void
    {
        self.result = result
        self.error =  nil
        self.cards += result.data
        
        debugPrint("Result: \(result.warnings?.count ?? 0) warnings")
        result.warnings?.forEach({ (warning) in
            debugPrint(warning)
        })
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.loadingData = false
            self.tableView.reloadData()
        })
    }
    
    /// Handles database errors from new search or loading more cards.
    ///
    /// - Parameters:
    ///     - error: The error object from database.
    private func errorHandler(_ error: RequestError) -> Void
    {
        self.result = nil
        self.error = error
        self.cards = []
        
        debugPrint("ERROR: \(error.warnings?.count ?? 0) warnings")
        error.warnings?.forEach({ (warning) in
            debugPrint(warning)
        })
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.loadingData = false
            self.tableView.reloadData()
        })
    }

}
