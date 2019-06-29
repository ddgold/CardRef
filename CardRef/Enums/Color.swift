//
//  Color.swift
//  CardRef
//
//  Created by Doug Goldstein on 6/12/19.
//  Copyright © 2019 Doug Goldstein. All rights reserved.
//

import Foundation

enum Color: String, Codable {
    case white = "W"
    case blue = "U"
    case black = "B"
    case red = "R"
    case green = "G"
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        if let color = Color(rawValue: raw) {
            self = color
        }
        else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid color value: '\(raw)'")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}
