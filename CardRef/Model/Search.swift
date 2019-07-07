//
//  Search.swift
//  CardRef
//
//  Created by Doug Goldstein on 6/16/19.
//  Copyright © 2019 Doug Goldstein. All rights reserved.
//

import Foundation

/// A database search object.
struct Search {
    //MARK: - Properties
    /// A fulltext search query.
    let query: String
    /// The de-duplicating method.
    let unique: Unique
    /// The method to sort returned cards.
    let order: Order
    /// The direction to sort cards.
    let direction: Direction
    
    /// The URL for this search.
    var url: URL {
        let escaped = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return URL(string: "https://api.scryfall.com/cards/search?dir=\(direction.rawValue)&format=json&include_extras=false&include_multilingual=false&order=\(order.rawValue)&page=1&q=\(escaped)&unique=\(unique.rawValue)")!
    }
    
    
    
    //MARK: - Constructors
    /// Constructs a seach object, query must be provided, but all other parameters are optional.
    ///
    /// - Parameters:
    ///   - query: The search string.
    ///   - unique: The de-duplication method. Defaults to cards.
    ///   - order: The sort order. Defaults to name.
    ///   - direction: THe sort direction. Defaults to auto.
    init(query: String, unique: Unique = .cards, order: Order = .name, direction: Direction = .auto) {
        self.query = query
        self.unique = unique
        self.order = order
        self.direction = direction
    }
    
    
    
    //MARK: - Enums
    /// Enum of search order options.
    enum Order: String {
        /// List of search order options.
        static var options = ["Colors", "Converted Mana Cost", "Name", "Price, Euros", "Price, US Dollars", "Price, Tickets", "Release Date", "Rarity", "Set"]
        
        /// Sort cards by name, A → Z
        case name
        /// Sort cards by their set and collector number: AAA/#1 → ZZZ/#999
        case set
        /// Sort cards by their release date: Newest → Oldest
        case released
        /// Sort cards by their rarity: Common → Mythic
        case rarity
        /// Sort cards by their color and color identity: WUBRG → multicolor → colorless
        case color
        /// Sort cards by their lowest known U.S. Dollar price: 0.01 → highest, null last
        case usd
        /// Sort cards by their lowest known TIX price: 0.01 → highest, null last
        case tix
        /// Sort cards by their lowest known Euro price: 0.01 → highest, null last
        case eur
        /// Sort cards by their converted mana cost: 0 → highest
        case cmc
        /// Sort cards by their power: null → highest
        case power
        /// Sort cards by their toughness: null → highest
        case toughness
        /// Sort cards by their EDHREC ranking: lowest → highest
        case edhrec
        /// Sort cards by their front-side artist name: A → Z
        case artist
    }
    
    /// Enum of search direction options.
    enum Direction: String {
        /// List of search direction options.
        static var options = ["Automatic", "Ascending", "Decsending"]
        
        /// Automatically choose the most inuitive direction to sort
        case auto
        /// Sort ascending, lowest to heighest
        case asc
        /// Sort descending, heighest to lowest
        case desc
    }
    
    /// Enum of search de-duplicating methods.
    enum Unique: String {
        /// List of search de-duplicating method options.
        static var options = ["All prints", "Cards", "Unique Art"]
        
        /// Removes duplicate gameplay objects (cards that share a name and have the same functionality). For example, if your search matches more than one print of Pacifism, only one copy of Pacifism will be returned.
        case cards
        /// Returns only one copy of each unique artwork for matching cards. For example, if your search matches more than one print of Pacifism, one card with each different illustration for Pacifism will be returned, but any cards that duplicate artwork already in the results will be omitted.
        case art
        /// Returns all prints for all cards matched (disables rollup). For example, if your search matches more than one print of Pacifism, all matching prints will be returned.
        case prints
    }
}
