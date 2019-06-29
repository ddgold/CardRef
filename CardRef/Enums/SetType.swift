//
//  SetType.swift
//  CardRef
//
//  Created by Doug Goldstein on 6/13/19.
//  Copyright © 2019 Doug Goldstein. All rights reserved.
//

import Foundation

enum SetType: String, Codable {
    case core = "core"
    case expansion = "expansion"
    case masters = "masters"
    case masterpiece = "masterpiece"
    case fromTheVault = "from_the_vault"
    case spellbook = "spellbook"
    case premiumDeck = "premium_deck"
    case duelDeck = "duel_deck"
    case draftInnovation = "draft_innovation"
    case treasureChest = "treasure_chest"
    case commander = "commander"
    case planechase = "planechase"
    case archenemy = "archenemy"
    case vanguard = "vanguard"
    case funny = "funny"
    case starter = "starter"
    case box = "box"
    case promo = "promo"
    case token = "token"
    case memorabilia = "memorabilia"
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        if let setType = SetType(rawValue: raw) {
            self = setType
        }
        else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid set type value: '\(raw)'")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}
