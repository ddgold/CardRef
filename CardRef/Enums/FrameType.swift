//
//  FrameType.swift
//  CardRef
//
//  Created by Doug Goldstein on 3/22/20.
//  Copyright © 2020 Doug Goldstein. All rights reserved.
//

import Foundation

enum FrameType: String, Codable {
    case ninetyThree = "1993"
    case ninetySeven = "1997"
    case ohThree = "2003"
    case ohFive = "2015"
    case future = "future"
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        if let frameType = FrameType(rawValue: raw) {
            self = frameType
        }
        else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid frame type value: '\(raw)'")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}
