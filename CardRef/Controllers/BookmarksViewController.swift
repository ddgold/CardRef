//
//  BookmarksViewController.swift
//  CardRef
//
//  Created by Doug Goldstein on 6/14/19.
//  Copyright © 2019 Doug Goldstein. All rights reserved.
//

import UIKit

class BookmarksViewController: UITableViewController {
    
    /// The list of bookmarked cards.
    var cards = [Card]()

    //MARK: - UIViewController
    ///
    /// Creates a new bookmarks viewController, sets plain style.
    ///
    init() {
        super.init(style: .plain)
    }
    
    ///
    /// Decoder init not implemented.
    ///
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///
    /// Setup the intial state of the bookmark viewController.
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Bookmarks"
        tableView.backgroundView?.backgroundColor = .white
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "bookmarkCell")
        
        loadBookmarks()
    }
    
    
    //MARK: - UITableViewController
    ///
    /// Fixes the number of sections to 1.
    ///
    /// Returns: 1
    ///
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    ///
    /// Determines the number of items in collection.  Section should always be 0.
    ///
    /// Returns: Count of cards.
    ///
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        assert(section == 0)
        
        return cards.count
    }
    
    ///
    /// Dequeues a cell and updates it will new card.
    ///
    /// Returns: The updated dequeued cell.
    ///
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        assert(indexPath.row < cards.count)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookmarkCell", for: indexPath)

        cell.textLabel?.text = cards[indexPath.row].name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cardViewController = CardViewController()
        cardViewController.card = cards[indexPath.row]
        navigationController?.pushViewController(cardViewController, animated: true)
    }
    
    
    //MARK: - Private Functions
    private func loadBookmarks() {
        /*
        Datatank.card("3ee34158-867f-4685-8f2b-af9469b628c3", resultHandler: { (ragingGoblin) in
            self.cards.append(ragingGoblin)
            self.tableView.reloadData()
        })
        Datatank.card("864ad989-19a6-4930-8efc-bbc077a18c32", resultHandler: { (bushiTenderfoot) in
            self.cards.append(bushiTenderfoot)
            self.tableView.reloadData()
        })
        */
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
