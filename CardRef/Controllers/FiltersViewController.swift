//
//  FiltersViewController.swift
//  CardRef
//
//  Created by Doug Goldstein on 6/29/19.
//  Copyright © 2019 Doug Goldstein. All rights reserved.
//

import UIKit

class FiltersViewController: UITableViewController {
    //MARK: - Properties
    /// The list of filter cells
    private var sections = [(title: String?, cells: [(cell: UITableViewCell, handler: (() -> Void)?)])]()
    
    
    
    //MARK: - UIViewController
    /// Creates a new filters view controller, sets plain style.
    init() {
        super.init(style: .plain)
    }
    
    /// Decoder init not implemented.
    ///
    /// - Parameter aDecoder: The decoder.
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Setup the intial state of the filters view controller.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Filters"
        buildCells()
        
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
    ///   - indexPath: The path to cell.
    /// - Returns: The cell.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        assert(indexPath.section < sections.count)
        assert(indexPath.row < sections[indexPath.section].cells.count)
        
        return sections[indexPath.section].cells[indexPath.row].cell
    }
    
    /// Invokes the handler, if there is one, for the pressed cell.
    ///
    /// - Parameters:
    ///   - tableView: The table view.
    ///   - indexPath: The path to cell.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        assert(indexPath.section < sections.count)
        assert(indexPath.row < sections[indexPath.section].cells.count)
        
        if let handler = sections[indexPath.section].cells[indexPath.row].handler {
            handler()
        }
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
    
    /// Builds filter cells.
    private func buildCells() -> Void {
        advanceCells()
        sortCells()
    }
    
    /// Builds advance search filter cells.
    private func advanceCells() {
        var cells = [(cell: UITableViewCell, handler: (() -> Void)?)]()
        
        let colorCell = UITableViewCell()
        colorCell.textLabel?.text = "Colors"
        cells.append((cell: colorCell, handler: {
            let selectFilterController = SelectFilterViewController()
            var options = [(title: String, selected: Bool)]()
            Color.options.forEach({ (title) in
                options.append((title: title, selected: false))
            })
            selectFilterController.options = options
            selectFilterController.navigationItem.title = "Colors"
            selectFilterController.multiselect = true
            self.navigationController?.pushViewController(selectFilterController, animated: true)
        }))
        
        let cmcCell = UITableViewCell()
        cmcCell.textLabel?.text = "Converted Mana Cost"
        cells.append((cell: cmcCell, handler: {
            let statFilterController = StatFilterViewController()
            statFilterController.navigationItem.title = "Converted Mana Cost"
            self.navigationController?.pushViewController(statFilterController, animated: true)
        }))
        
        let rarityCell = UITableViewCell()
        rarityCell.textLabel?.text = "Rarity"
        cells.append((cell: rarityCell, handler: {
            let selectFilterController = SelectFilterViewController()
            var options = [(title: String, selected: Bool)]()
            Rarity.options.forEach({ (title) in
                options.append((title: title, selected: false))
            })
            selectFilterController.options = options
            selectFilterController.navigationItem.title = "Rarity"
            selectFilterController.multiselect = true
            self.navigationController?.pushViewController(selectFilterController, animated: true)
        }))
        
        sections.append((title: nil, cells: cells))
    }
    
    /// Build sort filter cells.
    private func sortCells() {
        var cells = [(cell: UITableViewCell, handler: (() -> Void)?)]()
        
        let uniqueCell = UITableViewCell()
        uniqueCell.textLabel?.text = "Unique"
        cells.append((cell: uniqueCell, handler: {
            let selectionController = SelectFilterViewController()
            var options = [(title: String, selected: Bool)]()
            Search.Unique.options.forEach({ (title) in
                options.append((title: title, selected: false))
            })
            selectionController.options = options
            selectionController.navigationItem.title = "Unique"
            self.navigationController?.pushViewController(selectionController, animated: true)
        }))
        
        let orderCell = UITableViewCell()
        orderCell.textLabel?.text = "Order"
        cells.append((cell: orderCell, handler: {
            let selectionController = SelectFilterViewController()
            var options = [(title: String, selected: Bool)]()
            Search.Order.options.forEach({ (title) in
                options.append((title: title, selected: false))
            })
            selectionController.options = options
            selectionController.navigationItem.title = "Order"
            self.navigationController?.pushViewController(selectionController, animated: true)
        }))
        
        let directionCell = UITableViewCell()
        directionCell.textLabel?.text = "Direction"
        cells.append((cell: directionCell, handler: {
            let selectionController = SelectFilterViewController()
            var options = [(title: String, selected: Bool)]()
            Search.Direction.options.forEach({ (title) in
                options.append((title: title, selected: false))
            })
            selectionController.options = options
            selectionController.navigationItem.title = "Direction"
            self.navigationController?.pushViewController(selectionController, animated: true)
        }))
        
        sections.append((title: "Sort", cells: cells))
    }
}
