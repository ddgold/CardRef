//
//  LabelTableViewCell.swift
//  CardRef
//
//  Created by Doug Goldstein on 6/18/19.
//  Copyright © 2019 Doug Goldstein. All rights reserved.
//

import UIKit

class LabelTableViewCell: UITableViewCell {
    //MARK: - Properties
    /// Activity indicator spinner.
    var label = CardLabel()
    
    
    
    //MARK: - Constructors
    /// Creates a new loading cell, with active spinned in the middle of cell.
    ///
    /// - Parameters:
    ///   - style: The cell's style.
    ///   - reuseIdentifier: The cell's reuse identifier.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Setup spinner in middle of cell
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
        
        // Listen for theme changes
        Theme.subscribe(self, selector: #selector(updateTheme(_:)))
        updateTheme(nil)
    }
    
    /// Decoder init not implemented.
    ///
    /// - Parameter aDecoder: The decoder.
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Public Functions
    /// Updates the view to the current theme.
    ///
    /// - Parameters:
    ///     - notification: Unused.
    ///
    @objc func updateTheme(_: Notification?)
    {
        backgroundColor = Theme.backgroundColor
        
        label.textColor = Theme.textColor
    }
}
