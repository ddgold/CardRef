//
//  CardTableViewCell.swift
//  CardRef
//
//  Created by Doug Goldstein on 6/17/19.
//  Copyright © 2019 Doug Goldstein. All rights reserved.
//

import UIKit

/// A card table view cell.
class CardTableViewCell: UITableViewCell {
    //MARK: - Properties
    /// Name label.
    private var nameLabel = CardLabel()
    /// Type line label.
    private var typeLabel = CardLabel()
    /// Mana cost label.
    private var costLabel = CardLabel()
    
    /// The card.
    var card: Card! {
        didSet {
            nameLabel.text = card.name
            typeLabel.text = card.typeLine
            costLabel.text = card.manaCost
        }
    }
    
    
    
    //MARK: - Constructors
    /// Creates a new card cell, with active spinned in the middle of cell.
    ///
    /// - Parameters:
    ///   - style: The cell's style.
    ///   - reuseIdentifier: The cell's reuse identifier.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        
        self.addSubview(typeLabel)
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        typeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        typeLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
        
        costLabel.textAlignment = .right
        self.addSubview(costLabel)
        costLabel.translatesAutoresizingMaskIntoConstraints = false
        costLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        costLabel.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor).isActive = true
    }
    
    /// Decoder init not implemented.
    ///
    /// - Parameter aDecoder: The decoder.
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
