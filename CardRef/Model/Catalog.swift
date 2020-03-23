//
//  Catalog.swift
//  CardRef
//
//  Created by Doug Goldstein on 3/22/20.
//  Copyright © 2020 Doug Goldstein. All rights reserved.
//

import Foundation

/// Catalog object.
struct Catalog: Codable {
    //MARK: - Properties
    /// A link to the current catalog on Scryfall’s API.
    let uri: URL
    /// The number of items in the data array.
    let totalValues: Int
    /// An array of datapoints, as strings.
    let data: [String]
    
    
    
    //MARK: - Constructors
    /// Decodes a catalog object.
    ///
    /// - Parameter decoder: The decoder object.
    /// - Throws: DecodingError if invaild value.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let object = try container.decode(String.self, forKey: .object)
        assert(object == "catalog")
        
        self.uri = try container.decode(URL.self, forKey: .uri)
        self.totalValues = try container.decode(Int.self, forKey: .totalValues)
        self.data = try container.decode([String].self, forKey: .data)
        assert(totalValues == data.count)
    }
    
    
    
    //MARK: - Enums
    /// Enum of catalog names.
    public enum Name: String {
        case cardNames = "card-names"
        case artistNames = "artist-names"
        case wordBank = "word-bank"
        case creatureTypes = "creature-types"
        case planeswalkerTypes = "planeswalker-types"
        case landTypes = "land-types"
        case artifactTypes = "artifact-types"
        case enchantmentTypes = "enchantment-types"
        case spellTypes = "spell-types"
        case powers = "powers"
        case toughnesses = "toughnesses"
        case loyalties = "loyalties"
        case watermarks = "watermarks"
    }
    
    /// Enum of deserializer keys.
    private enum Keys: String, CodingKey {
        case uri
        case totalValues = "total_values"
        case data
        case object
    }
}
