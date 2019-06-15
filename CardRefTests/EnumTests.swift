//
//  EnumTests.swift
//  CardRefTests
//
//  Created by Doug Goldstein on 6/11/19.
//  Copyright © 2019 Doug Goldstein. All rights reserved.
//

import XCTest
@testable import CardRef

class EnumTests: XCTestCase {
    
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    // MARK: - Color
    func testDecodeColor() throws {
        let white = try decoder.decode([Color].self, from: "[\"W\"]".data(using: .utf8)!)
        XCTAssert(white == [.white])
        
        let blue = try decoder.decode([Color].self, from: "[\"U\"]".data(using: .utf8)!)
        XCTAssert(blue == [.blue])
        
        let black = try decoder.decode([Color].self, from: "[\"B\"]".data(using: .utf8)!)
        XCTAssert(black == [.black])
        
        let red = try decoder.decode([Color].self, from: "[\"R\"]".data(using: .utf8)!)
        XCTAssert(red == [.red])
        
        let green = try decoder.decode([Color].self, from: "[\"G\"]".data(using: .utf8)!)
        XCTAssert(green == [.green])
        
        do {
            _ = try decoder.decode([Color].self, from: "[\"F\"]".data(using: .utf8)!)
            XCTFail()
        }
        catch DecodingError.dataCorrupted(let context) {
            XCTAssert(context.debugDescription == "Invalid color value: 'F'")
        }
    }
    
    func testEncodeColor() throws {
        let white = String(data: try encoder.encode([Color.white]), encoding: .utf8)!
        XCTAssert(white == "[\"W\"]")
        
        let blue = String(data: try encoder.encode([Color.blue]), encoding: .utf8)!
        XCTAssert(blue == "[\"U\"]")
        
        let black = String(data: try encoder.encode([Color.black]), encoding: .utf8)!
        XCTAssert(black == "[\"B\"]")
        
        let red = String(data: try encoder.encode([Color.red]), encoding: .utf8)!
        XCTAssert(red == "[\"R\"]")
        
        let green = String(data: try encoder.encode([Color.green]), encoding: .utf8)!
        XCTAssert(green == "[\"G\"]")
    }
    
    
    // MARK: - Image Type
    func testDecodeImageType() throws {
        let png = try decoder.decode([ImageType].self, from: "[\"png\"]".data(using: .utf8)!)
        XCTAssert(png == [.png])
        
        let borderCrop = try decoder.decode([ImageType].self, from: "[\"border_crop\"]".data(using: .utf8)!)
        XCTAssert(borderCrop == [.borderCrop])
        
        let artCrop = try decoder.decode([ImageType].self, from: "[\"art_crop\"]".data(using: .utf8)!)
        XCTAssert(artCrop == [.artCrop])
        
        let large = try decoder.decode([ImageType].self, from: "[\"large\"]".data(using: .utf8)!)
        XCTAssert(large == [.large])
        
        let normal = try decoder.decode([ImageType].self, from: "[\"normal\"]".data(using: .utf8)!)
        XCTAssert(normal == [.normal])
        
        let small = try decoder.decode([ImageType].self, from: "[\"small\"]".data(using: .utf8)!)
        XCTAssert(small == [.small])
        
        do {
            _ = try decoder.decode([ImageType].self, from: "[\"failure\"]".data(using: .utf8)!)
            XCTFail()
        }
        catch DecodingError.dataCorrupted(let context) {
            XCTAssert(context.debugDescription == "Invalid image type value: 'failure'")
        }
    }
    
    func testEncodeImageType() throws {
        let png = String(data: try encoder.encode([ImageType.png]), encoding: .utf8)!
        XCTAssert(png == "[\"png\"]")
        
        let borderCrop = String(data: try encoder.encode([ImageType.borderCrop]), encoding: .utf8)!
        XCTAssert(borderCrop == "[\"border_crop\"]")
        
        let artCrop = String(data: try encoder.encode([ImageType.artCrop]), encoding: .utf8)!
        XCTAssert(artCrop == "[\"art_crop\"]")
        
        let large = String(data: try encoder.encode([ImageType.large]), encoding: .utf8)!
        XCTAssert(large == "[\"large\"]")
        
        let normal = String(data: try encoder.encode([ImageType.normal]), encoding: .utf8)!
        XCTAssert(normal == "[\"normal\"]")
        
        let small = String(data: try encoder.encode([ImageType.small]), encoding: .utf8)!
        XCTAssert(small == "[\"small\"]")
    }
    
    
    // MARK: - Layout
    func testDecodeLayout() throws {
        let normal = try decoder.decode([Layout].self, from: "[\"normal\"]".data(using: .utf8)!)
        XCTAssert(normal == [.normal])
        
        let split = try decoder.decode([Layout].self, from: "[\"split\"]".data(using: .utf8)!)
        XCTAssert(split == [.split])
        
        let flip = try decoder.decode([Layout].self, from: "[\"flip\"]".data(using: .utf8)!)
        XCTAssert(flip == [.flip])
        
        let transform = try decoder.decode([Layout].self, from: "[\"transform\"]".data(using: .utf8)!)
        XCTAssert(transform == [.transform])
        
        let meld = try decoder.decode([Layout].self, from: "[\"meld\"]".data(using: .utf8)!)
        XCTAssert(meld == [.meld])
        
        let leveler = try decoder.decode([Layout].self, from: "[\"leveler\"]".data(using: .utf8)!)
        XCTAssert(leveler == [.leveler])
        
        let saga = try decoder.decode([Layout].self, from: "[\"saga\"]".data(using: .utf8)!)
        XCTAssert(saga == [.saga])
        
        let planar = try decoder.decode([Layout].self, from: "[\"planar\"]".data(using: .utf8)!)
        XCTAssert(planar == [.planar])
        
        let scheme = try decoder.decode([Layout].self, from: "[\"scheme\"]".data(using: .utf8)!)
        XCTAssert(scheme == [.scheme])
        
        let vanguard = try decoder.decode([Layout].self, from: "[\"vanguard\"]".data(using: .utf8)!)
        XCTAssert(vanguard == [.vanguard])
        
        let token = try decoder.decode([Layout].self, from: "[\"token\"]".data(using: .utf8)!)
        XCTAssert(token == [.token])
        
        let doubleFacedToken = try decoder.decode([Layout].self, from: "[\"double_faced_token\"]".data(using: .utf8)!)
        XCTAssert(doubleFacedToken == [.doubleFacedToken])
        
        let emblem = try decoder.decode([Layout].self, from: "[\"emblem\"]".data(using: .utf8)!)
        XCTAssert(emblem == [.emblem])
        
        let augment = try decoder.decode([Layout].self, from: "[\"augment\"]".data(using: .utf8)!)
        XCTAssert(augment == [.augment])
        
        let host = try decoder.decode([Layout].self, from: "[\"host\"]".data(using: .utf8)!)
        XCTAssert(host == [.host])
        
        do {
            _ = try decoder.decode([Layout].self, from: "[\"failure\"]".data(using: .utf8)!)
            XCTFail()
        }
        catch DecodingError.dataCorrupted(let context) {
            XCTAssert(context.debugDescription == "Invalid layout value: 'failure'")
        }
    }
    
    
    func testEncodeLayout() throws {
        let normal = String(data: try encoder.encode([Layout.normal]), encoding: .utf8)!
        XCTAssert(normal == "[\"normal\"]")
        
        let split = String(data: try encoder.encode([Layout.split]), encoding: .utf8)!
        XCTAssert(split == "[\"split\"]")
        
        let flip = String(data: try encoder.encode([Layout.flip]), encoding: .utf8)!
        XCTAssert(flip == "[\"flip\"]")
        
        let transform = String(data: try encoder.encode([Layout.transform]), encoding: .utf8)!
        XCTAssert(transform == "[\"transform\"]")
        
        let meld = String(data: try encoder.encode([Layout.meld]), encoding: .utf8)!
        XCTAssert(meld == "[\"meld\"]")
        
        let leveler = String(data: try encoder.encode([Layout.leveler]), encoding: .utf8)!
        XCTAssert(leveler == "[\"leveler\"]")
        
        let saga = String(data: try encoder.encode([Layout.saga]), encoding: .utf8)!
        XCTAssert(saga == "[\"saga\"]")
        
        let planar = String(data: try encoder.encode([Layout.planar]), encoding: .utf8)!
        XCTAssert(planar == "[\"planar\"]")
        
        let scheme = String(data: try encoder.encode([Layout.scheme]), encoding: .utf8)!
        XCTAssert(scheme == "[\"scheme\"]")
        
        let vanguard = String(data: try encoder.encode([Layout.vanguard]), encoding: .utf8)!
        XCTAssert(vanguard == "[\"vanguard\"]")
        
        let token = String(data: try encoder.encode([Layout.token]), encoding: .utf8)!
        XCTAssert(token == "[\"token\"]")
        
        let doubleFacedToken = String(data: try encoder.encode([Layout.doubleFacedToken]), encoding: .utf8)!
        XCTAssert(doubleFacedToken == "[\"double_faced_token\"]")
        
        let emblem = String(data: try encoder.encode([Layout.emblem]), encoding: .utf8)!
        XCTAssert(emblem == "[\"emblem\"]")
        
        let augment = String(data: try encoder.encode([Layout.augment]), encoding: .utf8)!
        XCTAssert(augment == "[\"augment\"]")
        
        let host = String(data: try encoder.encode([Layout.host]), encoding: .utf8)!
        XCTAssert(host == "[\"host\"]")
    }
    
    
    // MARK: - Legality
    func testDecodeLegality() throws {
        let legal = try decoder.decode([Legality].self, from: "[\"legal\"]".data(using: .utf8)!)
        XCTAssert(legal == [.legal])
        
        let notLegal = try decoder.decode([Legality].self, from: "[\"not_legal\"]".data(using: .utf8)!)
        XCTAssert(notLegal == [.notLegal])
        
        let restricted = try decoder.decode([Legality].self, from: "[\"restricted\"]".data(using: .utf8)!)
        XCTAssert(restricted == [.restricted])
        
        let banned = try decoder.decode([Legality].self, from: "[\"banned\"]".data(using: .utf8)!)
        XCTAssert(banned == [.banned])

        do {
            _ = try decoder.decode([Legality].self, from: "[\"failure\"]".data(using: .utf8)!)
            XCTFail()
        }
        catch DecodingError.dataCorrupted(let context) {
            XCTAssert(context.debugDescription == "Invalid legality value: 'failure'")
        }
    }
    
    func testEncodeLegality() throws {
        let legal = String(data: try encoder.encode([Legality.legal]), encoding: .utf8)!
        XCTAssert(legal == "[\"legal\"]")
        
        let notLegal = String(data: try encoder.encode([Legality.notLegal]), encoding: .utf8)!
        XCTAssert(notLegal == "[\"not_legal\"]")
        
        let restricted = String(data: try encoder.encode([Legality.restricted]), encoding: .utf8)!
        XCTAssert(restricted == "[\"restricted\"]")
        
        let banned = String(data: try encoder.encode([Legality.banned]), encoding: .utf8)!
        XCTAssert(banned == "[\"banned\"]")
    }
    
    
    // MARK: - Related Type
    func testDecodeRelatedType() throws {
        let token = try decoder.decode([RelatedType].self, from: "[\"token\"]".data(using: .utf8)!)
        XCTAssert(token == [.token])
        
        let meldPart = try decoder.decode([RelatedType].self, from: "[\"meld_part\"]".data(using: .utf8)!)
        XCTAssert(meldPart == [.meldPart])
        
        let meldResult = try decoder.decode([RelatedType].self, from: "[\"meld_result\"]".data(using: .utf8)!)
        XCTAssert(meldResult == [.meldResult])
        
        let comboPiece = try decoder.decode([RelatedType].self, from: "[\"combo_piece\"]".data(using: .utf8)!)
        XCTAssert(comboPiece == [.comboPiece])
        
        do {
            _ = try decoder.decode([RelatedType].self, from: "[\"failure\"]".data(using: .utf8)!)
            XCTFail()
        }
        catch DecodingError.dataCorrupted(let context) {
            XCTAssert(context.debugDescription == "Invalid related type value: 'failure'")
        }
    }
    
    func testEncodeRelatedType() throws {
        let token = String(data: try encoder.encode([RelatedType.token]), encoding: .utf8)!
        XCTAssert(token == "[\"token\"]")
        
        let meldPart = String(data: try encoder.encode([RelatedType.meldPart]), encoding: .utf8)!
        XCTAssert(meldPart == "[\"meld_part\"]")
        
        let meldResult = String(data: try encoder.encode([RelatedType.meldResult]), encoding: .utf8)!
        XCTAssert(meldResult == "[\"meld_result\"]")
        
        let comboPiece = String(data: try encoder.encode([RelatedType.comboPiece]), encoding: .utf8)!
        XCTAssert(comboPiece == "[\"combo_piece\"]")
    }
    
    
    // MARK: - Set Type
    func testDecodeSetType() throws {
        let core = try decoder.decode([SetType].self, from: "[\"core\"]".data(using: .utf8)!)
        XCTAssert(core == [.core])
        
        let expansion = try decoder.decode([SetType].self, from: "[\"expansion\"]".data(using: .utf8)!)
        XCTAssert(expansion == [.expansion])
        
        let masters = try decoder.decode([SetType].self, from: "[\"masters\"]".data(using: .utf8)!)
        XCTAssert(masters == [.masters])
        
        let masterpiece = try decoder.decode([SetType].self, from: "[\"masterpiece\"]".data(using: .utf8)!)
        XCTAssert(masterpiece == [.masterpiece])
        
        let fromTheVault = try decoder.decode([SetType].self, from: "[\"from_the_vault\"]".data(using: .utf8)!)
        XCTAssert(fromTheVault == [.fromTheVault])
        
        let spellbook = try decoder.decode([SetType].self, from: "[\"spellbook\"]".data(using: .utf8)!)
        XCTAssert(spellbook == [.spellbook])
        
        let premiumDeck = try decoder.decode([SetType].self, from: "[\"premium_deck\"]".data(using: .utf8)!)
        XCTAssert(premiumDeck == [.premiumDeck])
        
        let duelDeck = try decoder.decode([SetType].self, from: "[\"duel_deck\"]".data(using: .utf8)!)
        XCTAssert(duelDeck == [.duelDeck])
        
        let draftInnovation = try decoder.decode([SetType].self, from: "[\"draft_innovation\"]".data(using: .utf8)!)
        XCTAssert(draftInnovation == [.draftInnovation])
        
        let treasureChest = try decoder.decode([SetType].self, from: "[\"treasure_chest\"]".data(using: .utf8)!)
        XCTAssert(treasureChest == [.treasureChest])
        
        let commander = try decoder.decode([SetType].self, from: "[\"commander\"]".data(using: .utf8)!)
        XCTAssert(commander == [.commander])
        
        let planechase = try decoder.decode([SetType].self, from: "[\"planechase\"]".data(using: .utf8)!)
        XCTAssert(planechase == [.planechase])
        
        let archenemy = try decoder.decode([SetType].self, from: "[\"archenemy\"]".data(using: .utf8)!)
        XCTAssert(archenemy == [.archenemy])
        
        let vanguard = try decoder.decode([SetType].self, from: "[\"vanguard\"]".data(using: .utf8)!)
        XCTAssert(vanguard == [.vanguard])
        
        let funny = try decoder.decode([SetType].self, from: "[\"funny\"]".data(using: .utf8)!)
        XCTAssert(funny == [.funny])
        
        let starter = try decoder.decode([SetType].self, from: "[\"starter\"]".data(using: .utf8)!)
        XCTAssert(starter == [.starter])
        
        let box = try decoder.decode([SetType].self, from: "[\"box\"]".data(using: .utf8)!)
        XCTAssert(box == [.box])
        
        let promo = try decoder.decode([SetType].self, from: "[\"promo\"]".data(using: .utf8)!)
        XCTAssert(promo == [.promo])
        
        let token = try decoder.decode([SetType].self, from: "[\"token\"]".data(using: .utf8)!)
        XCTAssert(token == [.token])
        
        let memorabilia = try decoder.decode([SetType].self, from: "[\"memorabilia\"]".data(using: .utf8)!)
        XCTAssert(memorabilia == [.memorabilia])
        
        do {
            _ = try decoder.decode([SetType].self, from: "[\"failure\"]".data(using: .utf8)!)
            XCTFail()
        }
        catch DecodingError.dataCorrupted(let context) {
            XCTAssert(context.debugDescription == "Invalid set type value: 'failure'")
        }
    }
    
    func testEncodeSetType() throws {
        let core = String(data: try encoder.encode([SetType.core]), encoding: .utf8)!
        XCTAssert(core == "[\"core\"]")
        
        let expansion = String(data: try encoder.encode([SetType.expansion]), encoding: .utf8)!
        XCTAssert(expansion == "[\"expansion\"]")
        
        let masters = String(data: try encoder.encode([SetType.masters]), encoding: .utf8)!
        XCTAssert(masters == "[\"masters\"]")
        
        let masterpiece = String(data: try encoder.encode([SetType.masterpiece]), encoding: .utf8)!
        XCTAssert(masterpiece == "[\"masterpiece\"]")
        
        let fromTheVault = String(data: try encoder.encode([SetType.fromTheVault]), encoding: .utf8)!
        XCTAssert(fromTheVault == "[\"from_the_vault\"]")
        
        let spellbook = String(data: try encoder.encode([SetType.spellbook]), encoding: .utf8)!
        XCTAssert(spellbook == "[\"spellbook\"]")
        
        let premiumDeck = String(data: try encoder.encode([SetType.premiumDeck]), encoding: .utf8)!
        XCTAssert(premiumDeck == "[\"premium_deck\"]")
        
        let duelDeck = String(data: try encoder.encode([SetType.duelDeck]), encoding: .utf8)!
        XCTAssert(duelDeck == "[\"duel_deck\"]")
        
        let draftInnovation = String(data: try encoder.encode([SetType.draftInnovation]), encoding: .utf8)!
        XCTAssert(draftInnovation == "[\"draft_innovation\"]")
        
        let treasureChest = String(data: try encoder.encode([SetType.treasureChest]), encoding: .utf8)!
        XCTAssert(treasureChest == "[\"treasure_chest\"]")
        
        let commander = String(data: try encoder.encode([SetType.commander]), encoding: .utf8)!
        XCTAssert(commander == "[\"commander\"]")
        
        let planechase = String(data: try encoder.encode([SetType.planechase]), encoding: .utf8)!
        XCTAssert(planechase == "[\"planechase\"]")
        
        let archenemy = String(data: try encoder.encode([SetType.archenemy]), encoding: .utf8)!
        XCTAssert(archenemy == "[\"archenemy\"]")
        
        let vanguard = String(data: try encoder.encode([SetType.vanguard]), encoding: .utf8)!
        XCTAssert(vanguard == "[\"vanguard\"]")
        
        let funny = String(data: try encoder.encode([SetType.funny]), encoding: .utf8)!
        XCTAssert(funny == "[\"funny\"]")
        
        let starter = String(data: try encoder.encode([SetType.starter]), encoding: .utf8)!
        XCTAssert(starter == "[\"starter\"]")
        
        let box = String(data: try encoder.encode([SetType.box]), encoding: .utf8)!
        XCTAssert(box == "[\"box\"]")
        
        let promo = String(data: try encoder.encode([SetType.promo]), encoding: .utf8)!
        XCTAssert(promo == "[\"promo\"]")
        
        let token = String(data: try encoder.encode([SetType.token]), encoding: .utf8)!
        XCTAssert(token == "[\"token\"]")
        
        let memorabilia = String(data: try encoder.encode([SetType.memorabilia]), encoding: .utf8)!
        XCTAssert(memorabilia == "[\"memorabilia\"]")
    }
}
