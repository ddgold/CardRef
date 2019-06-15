//
//  CardTests.swift
//  CardRefTests
//
//  Created by Doug Goldstein on 6/12/19.
//  Copyright © 2019 Doug Goldstein. All rights reserved.
//

import XCTest
@testable import CardRef

class CardTests: XCTestCase {
    
    let decoder = JSONDecoder()
    
    func testRagingGoblin() throws {
        let url = URL(string: "https://api.scryfall.com/cards/3ee34158-867f-4685-8f2b-af9469b628c3")!
        do {
            let ragingGoblin = try self.decoder.decode(Card.self, from: try Data(contentsOf: url))
            
            XCTAssert(ragingGoblin.name == "Raging Goblin")
            XCTAssert(ragingGoblin.cmc == 1)
            XCTAssert(ragingGoblin.colors == [.red])
            XCTAssert(ragingGoblin.uri == url)
        }
        catch {
            print("\n\(error)\n")
            XCTFail()
        }
    }
    
    func testBushiTenderfoot() throws {
        let url = URL(string: "https://api.scryfall.com/cards/864ad989-19a6-4930-8efc-bbc077a18c32")!
        do {
            let bushiTenderfoot = try self.decoder.decode(Card.self, from: try Data(contentsOf: url))
            
            XCTAssert(bushiTenderfoot.name == "Bushi Tenderfoot // Kenzo the Hardhearted")
            XCTAssert(bushiTenderfoot.cmc == 1)
            XCTAssert(bushiTenderfoot.colors == [.white])
            XCTAssert(bushiTenderfoot.uri == url)
        }
        catch {
            print("\n\(error)\n")
            XCTFail()
        }
    }
}
