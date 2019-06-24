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
    private var cells = [[UITableViewCell]]()
    
    /// The card.
    var card: Card? {
        didSet
        {
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
        
        tableView.backgroundView?.backgroundColor = .white
        
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
        return cells.count
    }
    
    /// Determines the number of items in collection.
    ///
    /// - Parameters:
    ///   - tableView: The table view.
    ///   - section: The section number.
    /// - Returns: The number of cells in section.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        assert(section < cells.count)
        
        return cells[section].count
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
    /// - Returns: A blank header view.
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UITableViewHeaderFooterView()
    }
    
    /// Determines the height of the footer for a section.
    ///
    /// - Parameters:
    ///   - tableView: The table view.
    ///   - section: The section number.
    /// - Returns: 20
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    /// Returns the footer cell for a section.
    ///
    /// - Parameters:
    ///   - tableView: The table view.
    ///   - section: The section number.
    /// - Returns: A blank footer view.
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UITableViewHeaderFooterView()
    }
    
    /// Gets cells from pre-built list.
    ///
    /// - Parameters:
    ///   - tableView: The table view.
    ///   - indexPath: The path to cell, section must be 0, and row less then number of cells.
    /// - Returns: The cell.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        assert(indexPath.section < cells.count)
        assert(indexPath.row < cells[indexPath.section].count)
        
        return cells[indexPath.section][indexPath.row]
    }
    
    
    
    //MARK: - Public Functions
    /// Updates the view to the current theme.
    ///
    /// - Parameters:
    ///   - notification: Unused.
    @objc func updateTheme(_: Notification?)
    {
        self.navigationController?.navigationBar.barStyle = Theme.barStyle
        self.tabBarController?.tabBar.barStyle = Theme.barStyle
        self.tableView.backgroundColor = Theme.backgroundColor
    }
    
    
    
    //MARK: - Private Functions
    /// Rebuilds the list of cells when the card is changed
    private func updateCells() {
        cells = []
        
        guard let card = self.card else {
            return
        }
        
        if let faces = card.cardFaces {
            for face in faces {
                var section = [UITableViewCell]()
                
                let nameCell = LabelTableViewCell()
                nameCell.label.style = .bold
                nameCell.label.text = "\(face.name)  \(face.manaCost ?? "")"
                section.append(nameCell)
                
                let typeCell = LabelTableViewCell()
                typeCell.label.text = face.typeLine
                section.append(typeCell)
                
                if let text = face.oracleText, !text.isEmpty {
                    let textCell = LabelTableViewCell()
                    textCell.label.multiLine = true
                    textCell.label.text = text
                    section.append(textCell)
                }
                
                if let flavor = face.flavorText, !flavor.isEmpty {
                    let flavorCell = LabelTableViewCell()
                    flavorCell.label.multiLine = true
                    flavorCell.label.style = .italic
                    flavorCell.label.text = flavor
                    section.append(flavorCell)
                }
                else if let flavor = card.flavorText, !flavor.isEmpty {
                    let flavorCell = LabelTableViewCell()
                    flavorCell.label.multiLine = true
                    flavorCell.label.style = .italic
                    flavorCell.label.text = flavor
                    section.append(flavorCell)
                }
                
                if let power = face.power, let toughness = face.toughness {
                    let pAndTCell = LabelTableViewCell()
                    pAndTCell.label.text = "\(power) / \(toughness)"
                    section.append(pAndTCell)
                }
                
                cells.append(section)
            }
        }
        else {
            var section = [UITableViewCell]()
            
            let nameCell = LabelTableViewCell()
            nameCell.label.style = .bold
            nameCell.label.text = "\(card.name)  \(card.manaCost ?? "")"
            section.append(nameCell)
            
            let typeCell = LabelTableViewCell()
            typeCell.label.text = card.typeLine
            section.append(typeCell)
            
            if let text = card.oracleText, !text.isEmpty {
                let textCell = LabelTableViewCell()
                textCell.label.multiLine = true
                textCell.label.text = text
                section.append(textCell)
            }
            
            if let flavor = card.flavorText, !flavor.isEmpty {
                let flavorCell = LabelTableViewCell()
                flavorCell.label.multiLine = true
                flavorCell.label.style = .italic
                flavorCell.label.text = flavor
                section.append(flavorCell)
            }
            
            if let power = card.power, let toughness = card.toughness {
                let powerToughnessCell = LabelTableViewCell()
                powerToughnessCell.label.text = "\(power) / \(toughness)"
                section.append(powerToughnessCell)
            }
            else if let handSize = card.handModifier, let startingLife = card.lifeModifier
            {
                let handSizeStartingLifeCell = LabelTableViewCell()
                handSizeStartingLifeCell.label.style = .bold
                handSizeStartingLifeCell.label.text = "Hand Size: \(handSize)\nStarting Life: \(startingLife)"
                section.append(handSizeStartingLifeCell)
            }
            
            cells.append(section)
        }
    }
}
