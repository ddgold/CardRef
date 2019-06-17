//
//  SearchTests.swift
//  CardRefTests
//
//  Created by Doug Goldstein on 6/16/19.
//  Copyright © 2019 Doug Goldstein. All rights reserved.
//

import XCTest
@testable import CardRef

class SearchTests: XCTestCase {
    
    func testURLs() {
        let defaults = Search(query: "testing defaults")
        XCTAssert(defaults.url == URL(string: "https://api.scryfall.com/cards/search?q=testing%20defaults&order=name&dir=auto")!)
        
        let colorAscending = Search(query: "testing", order: .color, dir: .asc)
        XCTAssert(colorAscending.url == URL(string: "https://api.scryfall.com/cards/search?q=testing&order=color&dir=asc")!)
        
        let rarityDescending = Search(query: "test?", order: .rarity, dir: .desc)
        XCTAssert(rarityDescending.url == URL(string: "https://api.scryfall.com/cards/search?q=test?&order=rarity&dir=desc")!)
        
        let powerAuto = Search(query: "last one's", order: .power, dir: .auto)
        XCTAssert(powerAuto.url == URL(string: "https://api.scryfall.com/cards/search?q=last%20one's&order=power&dir=auto")!)
    }
    
    func testColorAscending() {
        let expectation = self.expectation(description: "Search database sorted by color, ascending")
        
        let search = Search(query: "lord", order: .color, dir: .asc)
        Datatank.search(search, resultHandler: { (result) in
            XCTAssert(result.data.count == 77)
            XCTAssert(result.data[0].name == "Konda, Lord of Eiganjo")
            XCTAssert(result.data[0].colors == [.white])
            expectation.fulfill()
        }) { (resultError) in
            XCTFail()
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCmcDescending() {
        let expectation = self.expectation(description: "Search database sorted by cmc, descending")
        
        let search = Search(query: "lord", order: .cmc, dir: .desc)
        Datatank.search(search, resultHandler: { (result) in
            XCTAssert(result.data.count == 77)
            XCTAssert(result.data[0].name == "Kuro, Pitlord")
            XCTAssert(result.data[0].cmc == 9)
            expectation.fulfill()
        }) { (resultError) in
            XCTFail()
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testRarityAuto() {
        let expectation = self.expectation(description: "Search database sorted by rarity, auto")
        
        let search = Search(query: "lord", order: .rarity, dir: .auto)
        Datatank.search(search, resultHandler: { (result) in
            XCTAssert(result.data.count == 77)
            XCTAssert(result.data[0].name == "Bloodlord of Vaasgoth")
            XCTAssert(result.data[0].rarity == "mythic")
            expectation.fulfill()
        }) { (resultError) in
            XCTFail()
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
