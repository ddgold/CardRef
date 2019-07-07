//
//  Rarity.swift
//  CardRef
//
//  Created by Doug Goldstein on 6/13/19.
//  Copyright © 2019 Doug Goldstein. All rights reserved.
//

import Foundation

enum Rarity: String, Codable {
    /// List of colors.
    static let options = ["Common", "Uncommon", "Rare", "Mythic Rare"]
    
    case common
    case uncommon
    case rare
    case mythic
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        if let rarity = Rarity(rawValue: raw) {
            self = rarity
        }
        else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid rarity value: '\(raw)'")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}
