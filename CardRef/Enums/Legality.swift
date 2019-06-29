//
//  Legality.swift
//  CardRef
//
//  Created by Doug Goldstein on 6/11/19.
//  Copyright © 2019 Doug Goldstein. All rights reserved.
//

import Foundation

enum Legality: String, Codable {
    case legal = "legal"
    case notLegal = "not_legal"
    case restricted = "restricted"
    case banned = "banned"
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        if let legality = Legality(rawValue: raw) {
            self = legality
        }
        else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid legality value: '\(raw)'")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}
