//
//  FrameEffect.swift
//  CardRef
//
//  Created by Doug Goldstein on 3/22/20.
//  Copyright © 2020 Doug Goldstein. All rights reserved.
//

import Foundation

enum FrameEffect: String, Codable {
    case legendary = "legendary"
    case miracle = "miracle"
    case nyxtouched = "nyxtouched"
    case draft = "draft"
    case devoid = "devoid"
    case tombstone = "tombstone"
    case colorshifted = "colorshifted"
    case inverted = "inverted"
    case sunmoondfc = "sunmoondfc"
    case compasslanddfc = "compasslanddfc"
    case originpwdfc = "originpwdfc"
    case mooneldrazidfc = "mooneldrazidfc"
    case moonreversemoondfc = "moonreversemoondfc"
    case showcase = "showcase"
    case extendedart = "extendedart"
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        if let frameEffect = FrameEffect(rawValue: raw) {
            self = frameEffect
        }
        else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid frame effect value: '\(raw)'")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}
