//
//  RelatedType.swift
//  CardRef
//
//  Created by Doug Goldstein on 6/13/19.
//  Copyright © 2019 Doug Goldstein. All rights reserved.
//

import Foundation

enum RelatedType: String, Codable
{
    case token = "token"
    case meldPart = "meld_part"
    case meldResult = "meld_result"
    case comboPiece = "combo_piece"
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        if let relatedType = RelatedType(rawValue: raw) {
            self = relatedType
        }
        else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid related type value: '\(raw)'")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}
