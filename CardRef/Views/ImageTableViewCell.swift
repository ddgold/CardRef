//
//  ImageTableViewCell.swift
//  CardRef
//
//  Created by Doug Goldstein on 6/22/19.
//  Copyright © 2019 Doug Goldstein. All rights reserved.
//

import UIKit

/// An image table view cell.
class ImageTableViewCell: UITableViewCell {
    //MARK: - Properties
    /// Card image view.
    private var cardImage = UIImageView()
    
    /// A Card object.
    var card: Card? {
        didSet {
            cardImage.image = UIImage(named: "cardBack")
            
            if let card = card {
                Datatank.image(card, type: .large, resultHandler: resultHandler, errorHandler: errorHandler)
            }
        }
    }
    
    
    
    //MARK: - Constructors
    /// Creates a new loading cell, with active spinned in the middle of cell.
    ///
    /// - Parameters:
    ///   - style: The cell's style.
    ///   - reuseIdentifier: The cell's reuse identifier.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Setup image in middle of cell
        self.addSubview(cardImage)
        cardImage.translatesAutoresizingMaskIntoConstraints = false
        cardImage.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cardImage.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        cardImage.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        cardImage.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        cardImage.heightAnchor.constraint(equalTo: cardImage.widthAnchor, multiplier: CGFloat(1.4)).isActive = true
    }
    
    /// Decoder init not implemented.
    ///
    /// - Parameters:
    ///   - aDecoder: The decoder.
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Public Functions
    /// Removes previous card.
    override func prepareForReuse() {
        card = nil
    }
    
    /// Handles datatank results from downloading image.
    ///
    /// - Parameters:
    ///   - image: The image object.
    private func resultHandler(image: UIImage) -> Void {
        DispatchQueue.main.async(execute: { () -> Void in
            self.cardImage.image = image
        })
    }
    
    /// Handles datatank errors from downloading image.
    ///
    /// - Parameters:
    ///   - error: The error object from database.
    private func errorHandler(error: RequestError) -> Void {
        debugPrint(error)
    }
}
