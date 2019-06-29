//
//  Layout.swift
//  CardRef
//
//  Created by Doug Goldstein on 6/13/19.
//  Copyright © 2019 Doug Goldstein. All rights reserved.
//

import Foundation

enum Layout: String, Codable {
    case normal = "normal"
    case split = "split"
    case flip = "flip"
    case transform = "transform"
    case meld = "meld"
    case leveler = "leveler"
    case saga = "saga"
    case planar = "planar"
    case scheme = "scheme"
    case vanguard = "vanguard"
    case token = "token"
    case doubleFacedToken = "double_faced_token"
    case emblem = "emblem"
    case augment = "augment"
    case host = "host"
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        if let layout = Layout(rawValue: raw) {
            self = layout
        }
        else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid layout value: '\(raw)'")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}
