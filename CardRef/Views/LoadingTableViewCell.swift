//
//  LoadingTableViewCell.swift
//  CardRef
//
//  Created by Doug Goldstein on 6/17/19.
//  Copyright © 2019 Doug Goldstein. All rights reserved.
//

import UIKit

class LoadingTableViewCell: UITableViewHeaderFooterView {
    //MARK: - Properties
    /// Activity indicator spinner.
    private var spinner = UIActivityIndicatorView(style: .gray)
    
    
    
    //MARK: - Constructors
    /// Creates a new loading cell, with active spinned in the middle of cell.
    ///
    /// - Parameters:
    ///   - reuseIdentifier: The cell's reuse identifier.
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        // Setup spinner in middle of cell
        self.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        spinner.startAnimating()
        
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
    /// (Re)starts the spinning animation.
    override func prepareForReuse() {
        spinner.startAnimating()
    }
    
    /// Updates the view to the current theme.
    ///
    /// - Parameters:
    ///   - notification: Unused.
    @objc func updateTheme(_: Notification?) {
        backgroundColor = Theme.backgroundColor
        
        switch Theme.barStyle {
        case .default:
            spinner.style = .gray
        default:
            spinner.style = .white
        }
    }
}
