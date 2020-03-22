//
//  CardViewController.swift
//  CardRef
//
//  Created by Doug Goldstein on 6/15/19.
//  Copyright © 2019 Doug Goldstein. All rights reserved.
//

import UIKit

/// Single card view controller
class CardViewController: UITableViewController {
    //MARK: - Properties
    /// The list of cells, always built based on current card.
    private var sections = [(title: String?, cells: [UITableViewCell])]()
    
    /// Whether or not rulings are still downloading.
    private var loadingRulings = false
    
    /// The card.
    var card: Card? {
        didSet {
            navigationItem.title = card?.name
            updateCells()
        }
    }
    
    
    
    //MARK: - UIViewController
    /// Creates a new card view controller, sets plain style.
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
        
        tableView.allowsSelection = false
        
        tableView.register(LabelTableViewCell.self, forCellReuseIdentifier: "cardLineCell")
        
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
    
    /// Determines the height of the header for a section.
    ///
    /// - Parameters:
    ///   - tableView: The table view.
    ///   - section: The section number.
    /// - Returns: 0
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
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
    
    /// Returns the section's title.
    ///
    /// - Parameters:
    ///   - tableView: The table view.
    ///   - section: The section number.
    /// - Returns: The section's title, if there is one.
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    /// Determines the height of the footer for a section.
    ///
    /// - Parameters:
    ///   - tableView: The table view.
    ///   - section: The section number.
    /// - Returns: 20
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if loadingRulings && (section == sections.count - 1) {
            return 50
        }
        else {
            return 20
        }
    }
    
    /// Returns the footer cell for a section.
    ///
    /// - Parameters:
    ///   - tableView: The table view.
    ///   - section: The section number.
    /// - Returns: A blank footer cell.
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if loadingRulings && (section == sections.count - 1) {
            return LoadingTableViewCell()
        }
        else {
            return nil
        }
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
    /// Rebuilds the list of cells when the card is changed
    private func updateCells() {
        sections = []
        
        guard let card = self.card else {
            return
        }
        
        var cells = [UITableViewCell]()
        if let faces = card.cardFaces {
            for face in faces {
                let imageCell = ImageTableViewCell()
                imageCell.card = card
                cells.append(imageCell)
                
                let nameCell = LabelTableViewCell()
                nameCell.label.style = .bold
                nameCell.label.text = "\(face.name)  \(face.manaCost ?? "")"
                cells.append(nameCell)
                
                let typeCell = LabelTableViewCell()
                typeCell.label.text = face.typeLine
                cells.append(typeCell)
                
                if let text = face.oracleText, !text.isEmpty {
                    let textCell = LabelTableViewCell()
                    textCell.label.multiLine = true
                    textCell.label.text = text
                    cells.append(textCell)
                }
                
                if let flavor = face.flavorText, !flavor.isEmpty {
                    let flavorCell = LabelTableViewCell()
                    flavorCell.label.multiLine = true
                    flavorCell.label.style = .italic
                    flavorCell.label.text = flavor
                    cells.append(flavorCell)
                }
                else if let flavor = card.flavorText, !flavor.isEmpty {
                    let flavorCell = LabelTableViewCell()
                    flavorCell.label.multiLine = true
                    flavorCell.label.style = .italic
                    flavorCell.label.text = flavor
                    cells.append(flavorCell)
                }
                
                if let power = face.power, let toughness = face.toughness {
                    let pAndTCell = LabelTableViewCell()
                    pAndTCell.label.text = "\(power) / \(toughness)"
                    cells.append(pAndTCell)
                }
            }
        }
        else {
            let imageCell = ImageTableViewCell()
            imageCell.card = card
            cells.append(imageCell)
            
            let nameCell = LabelTableViewCell()
            nameCell.label.style = .bold
            nameCell.label.text = "\(card.name)  \(card.manaCost ?? "")"
            cells.append(nameCell)
            
            let typeCell = LabelTableViewCell()
            typeCell.label.text = card.typeLine
            cells.append(typeCell)
            
            if let text = card.oracleText, !text.isEmpty {
                let textCell = LabelTableViewCell()
                textCell.label.multiLine = true
                textCell.label.text = text
                cells.append(textCell)
            }
            
            if let flavor = card.flavorText, !flavor.isEmpty {
                let flavorCell = LabelTableViewCell()
                flavorCell.label.multiLine = true
                flavorCell.label.style = .italic
                flavorCell.label.text = flavor
                cells.append(flavorCell)
            }
            
            if let power = card.power, let toughness = card.toughness {
                let powerToughnessCell = LabelTableViewCell()
                powerToughnessCell.label.text = "\(power) / \(toughness)"
                cells.append(powerToughnessCell)
            }
            else if let handSize = card.handModifier, let startingLife = card.lifeModifier
            {
                let handSizeStartingLifeCell = LabelTableViewCell()
                handSizeStartingLifeCell.label.style = .bold
                handSizeStartingLifeCell.label.text = "Hand Size: \(handSize)\nStarting Life: \(startingLife)"
                cells.append(handSizeStartingLifeCell)
            }
        }
        
        sections.append((title: nil, cells: cells))
        loadRulings()
    }
    
    /// Load any rulings for this card. Does nothing if already loading rulings.
    private func loadRulings() {
        // Only allow one outstanding database call at once
        if loadingRulings {
            return
        }
        
        self.loadingRulings = true
        
        Datatank.rulings(card!, resultHandler: resultHandler, errorHandler: errorHandler)
    }
    
    /// Handles database results from loading rulings.
    ///
    /// - Parameters:
    ///   - result: The result object from database.
    private func resultHandler(result: List<Ruling>) -> Void {
        DispatchQueue.main.async(execute: { () -> Void in
            if result.data.count > 0 {
                var cells = [UITableViewCell]()
                
                for ruling in result.data {
                    let rulingCell = RulingTableViewCell()
                    rulingCell.ruling = ruling
                    cells.append(rulingCell)
                }
                
                self.sections.append((title: "Rulings", cells: cells))
            }
            
            self.loadingRulings = false
            self.tableView.reloadData()
        })
    }
    
    /// Handles database errors from loading ruling.
    ///
    /// - Parameters:
    ///   - error: The error object from database.
    private func errorHandler(_ error: RequestError) -> Void {
        DispatchQueue.main.async(execute: { () -> Void in
            self.loadingRulings = false
            self.tableView.reloadData()
        })
    }
}
