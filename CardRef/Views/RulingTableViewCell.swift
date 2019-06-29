//
//  RulingTableViewCell.swift
//  CardRef
//
//  Created by Doug Goldstein on 6/28/19.
//  Copyright © 2019 Doug Goldstein. All rights reserved.
//

import UIKit

class RulingTableViewCell: UITableViewCell {
    //MARK: - Properties
    /// Ruling comment label.
    private var commentLabel = CardLabel()
    /// Published date label.
    private var publishedLabel = CardLabel()
    
    /// The ruling.
    var ruling: Ruling! {
        didSet {
            commentLabel.text = ruling.comment
            publishedLabel.text = ruling.publishedAt
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
        
        commentLabel.multiLine = true
        self.addSubview(commentLabel)
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        commentLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        commentLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        
        publishedLabel.style = .italic
        self.addSubview(publishedLabel)
        publishedLabel.translatesAutoresizingMaskIntoConstraints = false
        publishedLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        publishedLabel.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: 8).isActive = true
        publishedLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        publishedLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
        
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
    @objc func updateTheme(_: Notification?) {
        backgroundColor = Theme.backgroundColor
        
        commentLabel.textColor = Theme.textColor
        publishedLabel.textColor = Theme.textColor
    }
}
