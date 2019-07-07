//
//  SelectFilterViewController.swift
//  CardRef
//
//  Created by Doug Goldstein on 7/3/19.
//  Copyright © 2019 Doug Goldstein. All rights reserved.
//

import UIKit

class SelectFilterViewController: UITableViewController {
    //MARK: - Properties
    var multiselect = false
    
    /// List of options to select from.
    var options = [(title: String, selected: Bool)]()
    
    
    
    //MARK: - UIViewController
    /// Creates a new selection filter view controller, sets plain style.
    init() {
        super.init(style: .plain)
    }
    
    /// Decoder init not implemented.
    ///
    /// - Parameter aDecoder: The decoder.
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Setup the intial state of the selection filter view controller.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "optionCell")
        
        // Listen for theme changes
        Theme.subscribe(self, selector: #selector(updateTheme(_:)))
        updateTheme(nil)
    }
    
    
    
    //MARK: - UITableViewController
    /// Determines the number of sections, always 1.
    ///
    /// - Parameter tableView: The table view.
    /// - Returns: The number of sections.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// Determines the number of items in collection.
    ///
    /// - Parameters:
    ///   - tableView: The table view.
    ///   - section: The section number.
    /// - Returns: The number of cells in section.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        assert(section == 0)
        return options.count
    }
    
    /// Gets cells from pre-built list.
    ///
    /// - Parameters:
    ///   - tableView: The table view.
    ///   - indexPath: The path to cell, section must be 0, and row less then number of cells.
    /// - Returns: The cell.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        assert(indexPath.section == 0)
        assert(indexPath.row < options.count)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "optionCell", for: indexPath) as? UITableViewCell else {
            fatalError("Unexpected cell type for optionCell.")
        }
        
        let option = options[indexPath.row]
        cell.textLabel?.text = option.title
        cell.accessoryType = option.selected ? .checkmark : .none
        
        return cell
    }
    
    /// Handles a cell being pressed.
    ///
    /// - Parameters:
    ///   - tableView: The table view.
    ///   - indexPath: The path to cell.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        assert(indexPath.section == 0)
        assert(indexPath.row < options.count)
        
        if !multiselect  {
            for index in 0..<options.count {
                options[index].selected = false
            }
        }
        
        options[indexPath.row].selected.toggle()
        
        tableView.reloadData()
    }
    
    
    
    //MARK: - Private Functions
    /// Updates the view to the current theme.
    ///
    /// - Parameters:
    ///   - notification: Unused.
    @objc private func updateTheme(_: Notification?) {
        self.navigationController?.navigationBar.barStyle = Theme.barStyle
        self.tabBarController?.tabBar.barStyle = Theme.barStyle
        self.tableView.backgroundColor = Theme.backgroundColor
    }
}
