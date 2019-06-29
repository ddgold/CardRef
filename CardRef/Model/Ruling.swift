//
//  Ruling.swift
//  CardRef
//
//  Created by Doug Goldstein on 6/23/19.
//  Copyright © 2019 Doug Goldstein. All rights reserved.
//

import Foundation

/// A card rule clarification object.
struct Ruling: Codable {
    //MARK: - Properties
    /// The oracle ID of ruling
    let oracleId: String
    /// A computer-readable string indicating which company produced this ruling, either wotc or scryfall.
    let source: String
    /// The date when the ruling or note was published.
    let publishedAt: String
    /// The text of the ruling.
    let comment: String
    
    
    
    //MARK: - Constructors
    /// Decodes a list object.
    ///
    /// - Parameter decoder: The decoder object.
    /// - Throws: DecodingError if invaild value.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let object = try container.decode(String.self, forKey: .object)
        assert(object == "ruling")
        
        self.oracleId = try container.decode(String.self, forKey: .oracleId)
        self.source = try container.decode(String.self, forKey: .source)
        self.publishedAt = try container.decode(String.self, forKey: .publishedAt)
        self.comment = try container.decode(String.self, forKey: .comment)
    }
    
    
    
    //MARK: - Enums
    /// Enum of deserializer keys.
    private enum Keys: String, CodingKey {
        case object
        case oracleId = "oracle_id"
        case source
        case publishedAt = "published_at"
        case comment
    }
}
