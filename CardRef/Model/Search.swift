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
    /// The method to sort returned cards.
    let order: Order
    /// The direction to sort cards.
    let dir: Direction
    
    /// The URL for this search.
    var url: URL {
        let escaped = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return URL(string: "https://api.scryfall.com/cards/search?q=\(escaped)&order=\(order.rawValue)&dir=\(dir.rawValue)")!
    }
    
    
    
    //MARK: - Constructors
    /// Constructs a seach object, query must be provided, but all other parameters are optional.
    ///
    /// - Parameters:
    ///   - query: The search string.
    ///   - order: The sort order. Defaults to name.
    ///   - dir: THe sort direction. Defaults to auto.
    init(query: String, order: Order = .name, dir: Direction = .auto) {
        self.query = query
        self.order = order
        self.dir = dir
    }
    
    
    
    //MARK: - Enums
    /// Enum of search order options.
    enum Order: String {
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
        /// Automatically choose the most inuitive direction to sort
        case auto
        /// Sort ascending, lowest to heighest
        case asc
        /// Sort descending, heighest to lowest
        case desc
    }
}
