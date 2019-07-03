//
//  FilterViewController.swift
//  CardRef
//
//  Created by Doug Goldstein on 6/29/19.
//  Copyright © 2019 Doug Goldstein. All rights reserved.
//

import UIKit

class FilterViewController: UITableViewController {
    //MARK: - Properties
    /// The list of cells, always built based on current card.
    private var sections = [(title: String?, cells: [UITableViewCell])]()
    
    
    
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
        
        navigationItem.title = "Filters"
        
        tableView.register(CardTableViewCell.self, forCellReuseIdentifier: "filterCell")
        
        updateCells()
        
        // Listen for theme changes
        Theme.subscribe(self, selector: #selector(updateTheme(_:)))
        updateTheme(nil)
    }
    
    
    
    //MARK: - UITableViewController
    /// Determines the number of sections.
    ///
    /// - Parameter tableView: The table view.
    /// - Returns: The number of sections.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    /// Determines the number of items in collection.
    ///
    /// - Parameters:
    ///   - tableView: The table view.
    ///   - section: The section number.
    /// - Returns: The number of cells in section.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        assert(section < sections.count)
        
        return sections[section].cells.count
    }
    
    /// Returns the section's title.
    ///
    /// - Parameters:
    ///   - tableView: The table view.
    ///   - section: The section number.
    /// - Returns: The section's title, if there is one.
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    /// Gets cells from pre-built list.
    ///
    /// - Parameters:
    ///   - tableView: The table view.
    ///   - indexPath: The path to cell, section must be 0, and row less then number of cells.
    /// - Returns: The cell.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        assert(indexPath.section < sections.count)
        assert(indexPath.row < sections[indexPath.section].cells.count)
        
        return sections[indexPath.section].cells[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(FilterViewController(), animated: true)
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
    
    private func updateCells() -> Void {
        for section in 0..<10 {
            var cells = [UITableViewCell]()
            
            let one = UITableViewCell()
            one.textLabel?.text = "one"
            cells.append(one)
            
            let two = UITableViewCell()
            two.textLabel?.text = "two"
            cells.append(two)
            
            let third = UITableViewCell()
            third.textLabel?.text = "third"
            cells.append(third)
            
            sections.append((title: "section #\(section)", cells: cells))
        }
    }
}
