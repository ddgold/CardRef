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
    private var cells = [UITableViewCell]()
    
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
        
        tableView.backgroundView?.backgroundColor = .white
        
        tableView.allowsSelection = false
        
        tableView.register(LabelTableViewCell.self, forCellReuseIdentifier: "cardLineCell")
        
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
        
        return cells.count
    }
    
    /// Gets cells from pre-built list.
    ///
    /// - Parameters:
    ///   - tableView: The table view.
    ///   - indexPath: The path to cell, section must be 0, and row less then number of cells.
    /// - Returns: The cell.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        assert(indexPath.section == 0)
        assert(indexPath.row < cells.count)
        
        return cells[indexPath.row]
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
                
                if let power = face.power, let toughness = face.toughness {
                    let pAndTCell = LabelTableViewCell()
                    pAndTCell.label.text = "\(power) / \(toughness)"
                    cells.append(pAndTCell)
                }
            }
        }
        else {
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
    }
}
