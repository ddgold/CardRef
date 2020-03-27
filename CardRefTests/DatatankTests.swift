//
//  DatatankTests.swift
//  CardRefTests
//
//  Created by Doug Goldstein on 6/12/19.
//  Copyright © 2019 Doug Goldstein. All rights reserved.
//

import XCTest
@testable import CardRef

class DatatankTests: XCTestCase {
    
    //MARK: - Cards
    func testDebugCards() {
        let cards = Datatank.cards("DebugCards")
        
        XCTAssert(cards.count == 1)
        
        let ragingGoblin = cards[0]
        XCTAssert(ragingGoblin.name == "Raging Goblin")
        XCTAssert(ragingGoblin.cmc == 1)
        XCTAssert(ragingGoblin.colors == [.red])
        
    }
    
    func testRagingGoblin() {
        let expectation = self.expectation(description: "Download Raging Goblin card")
        
        let id = "3ee34158-867f-4685-8f2b-af9469b628c3"
        Datatank.card(id, resultHandler: { (ragingGoblin) in
            XCTAssert(ragingGoblin.name == "Raging Goblin")
            XCTAssert(ragingGoblin.cmc == 1)
            XCTAssert(ragingGoblin.colors == [.red])
            XCTAssert(ragingGoblin.id == id)
            expectation.fulfill()
        }, errorHandler: { (requestError) in
            XCTFail()
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testBushiTenderfoot() {
        let expectation = self.expectation(description: "Download Bushi Tenderfoot card")
        
        let id = "864ad989-19a6-4930-8efc-bbc077a18c32"
        Datatank.card(id, resultHandler: { (bushiTenderfoot) in
            XCTAssert(bushiTenderfoot.name == "Bushi Tenderfoot // Kenzo the Hardhearted")
            XCTAssert(bushiTenderfoot.cmc == 1)
            XCTAssert(bushiTenderfoot.colors == [.white])
            XCTAssert(bushiTenderfoot.id == id)
            expectation.fulfill()
        }, errorHandler: { (requestError) in
            XCTFail()
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testInvalidCard() {
        let expectation = self.expectation(description: "Download an invalid card")
        
        let id = "failure"
        Datatank.card(id, resultHandler: { (failure) in
            XCTFail()
            expectation.fulfill()
        }, errorHandler: { (requestError) in
            XCTAssert(requestError.code == "not_found")
            XCTAssert(requestError.status == 404)
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    //MARK: - Catalog
    func testLandTypes() {
        let expectation = self.expectation(description: "Download land types catalog")
        
        Datatank.catalog(.landTypes, resultHandler: { (landTypes) in
            XCTAssert(landTypes.uri == URL(string: "https://api.scryfall.com/catalog/land-types")!)
            XCTAssert(landTypes.totalValues == 13)
            XCTAssert(landTypes.data[0] == "Desert")
            XCTAssert(landTypes.data[4] == "Lair")
            XCTAssert(landTypes.data[6] == "Mine")
            XCTAssert(landTypes.data[9] == "Power-Plant")
            expectation.fulfill()
        }, errorHandler: { (requestError) in
            XCTFail()
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testPowers() {
        let expectation = self.expectation(description: "Download land types catalog")
        
        Datatank.catalog(.powers, resultHandler: { (powers) in
            XCTAssert(powers.uri == URL(string: "https://api.scryfall.com/catalog/powers")!)
            XCTAssert(powers.totalValues == 34)
            XCTAssert(powers.data[1] == "?")
            XCTAssert(powers.data[4] == "*")
            XCTAssert(powers.data[11] == "1.5")
            XCTAssert(powers.data[20] == "+4")
            expectation.fulfill()
        }, errorHandler: { (requestError) in
            XCTFail()
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    //MARK: - Search
    func testSearchGoblin() {
        let expectation = self.expectation(description: "Search database for 'goblin'")
        
        let search = Search(query: "goblin")
        Datatank.search(search, resultHandler: { (result) in
            XCTAssert(result.data.count == 175)
            XCTAssert(result.hasMore == true)
            XCTAssert(result.nextPage == URL(string: "https://api.scryfall.com/cards/search?format=json&include_extras=false&include_multilingual=false&order=name&page=2&q=goblin&unique=cards")!)
            XCTAssert(result.totalCards == 197)
            XCTAssert(result.warnings == nil)
            
            Datatank.search(result, resultHandler: { (result) in
                XCTAssert(result.data.count == 22)
                XCTAssert(result.hasMore == false)
                XCTAssert(result.nextPage == nil)
                XCTAssert(result.totalCards == 197)
                XCTAssert(result.warnings == nil)
                
                expectation.fulfill()
            }, errorHandler: { (requestError) in
                XCTFail()
                expectation.fulfill()
            })
        }, errorHandler: { (requestError) in
            XCTFail()
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSearchFoot() {
        let expectation = self.expectation(description: "Search database for 'foot'")
        
        let search = Search(query: "foot")
        Datatank.search(search, resultHandler: { (result) in
            XCTAssert(result.data.count == 27)
            XCTAssert(result.hasMore == false)
            XCTAssert(result.nextPage == nil)
            XCTAssert(result.totalCards == 27)
            XCTAssert(result.warnings == nil)
            
            expectation.fulfill()
        }, errorHandler: { (requestError) in
            XCTFail()
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    //MARK: - Rulings
    func testDownDirty() {
        let expectation = self.expectation(description: "Download rules for card 'Down // Dirty'")
        
        let id = "c35c63c1-6344-4d8c-8f7d-cd253d12f9ae"
        Datatank.card(id, resultHandler: { (downDirty) in
            XCTAssert(downDirty.name == "Down // Dirty")
            XCTAssert(downDirty.id == id)
            
            Datatank.rulings(downDirty, resultHandler: { (rulings) in
                XCTAssert(rulings.data.count == 10)
                XCTAssert(rulings.hasMore == false)
                let ruling = rulings.data[0]
                XCTAssert(ruling.oracleId == "eba21e3b-e2b2-4e0b-82e3-f0849943fd89")
                XCTAssert(ruling.source == "wotc")
                XCTAssert(ruling.publishedAt == "2013-04-15")
                
                expectation.fulfill()
            }, errorHandler: { (requestError) in
                XCTFail()
                expectation.fulfill()
            })
        }, errorHandler: { (requestError) in
            XCTFail()
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
