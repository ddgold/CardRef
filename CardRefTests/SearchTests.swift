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
        XCTAssert(defaults.url == URL(string: "https://api.scryfall.com/cards/search?dir=auto&format=json&include_extras=false&include_multilingual=false&order=name&page=1&q=testing%20defaults&unique=cards")!)
        
        let colorAscending = Search(query: "testing", order: .color, direction: .asc)
        XCTAssert(colorAscending.url == URL(string: "https://api.scryfall.com/cards/search?dir=asc&format=json&include_extras=false&include_multilingual=false&order=color&page=1&q=testing&unique=cards")!)
        
        let rarityDescending = Search(query: "test?", unique: .prints, order: .rarity, direction: .desc)
        XCTAssert(rarityDescending.url == URL(string: "https://api.scryfall.com/cards/search?dir=desc&format=json&include_extras=false&include_multilingual=false&order=rarity&page=1&q=test?&unique=prints")!)
        
        let powerAuto = Search(query: "last one's", unique: .art, order: .power, direction: .auto)
        XCTAssert(powerAuto.url == URL(string: "https://api.scryfall.com/cards/search?dir=auto&format=json&include_extras=false&include_multilingual=false&order=power&page=1&q=last%20one's&unique=art")!)
    }
    
    func testColorAscending() {
        let expectation = self.expectation(description: "Search database sorted by color, ascending")
        
        let search = Search(query: "lord", order: .color, direction: .asc)
        Datatank.search(search, resultHandler: { (result) in
            XCTAssert(result.data.count == 81)
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
        
        let search = Search(query: "lord", order: .cmc, direction: .desc)
        Datatank.search(search, resultHandler: { (result) in
            XCTAssert(result.data.count == 81)
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
        
        let search = Search(query: "lord", order: .rarity, direction: .auto)
        Datatank.search(search, resultHandler: { (result) in
            XCTAssert(result.data.count == 81)
            XCTAssert(result.data[0].name == "Bloodlord of Vaasgoth")
            XCTAssert(result.data[0].rarity == Rarity.mythic)
            expectation.fulfill()
        }) { (resultError) in
            XCTFail()
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testUniquePrints() {
        let expectation = self.expectation(description: "Search database sorted by rarity, auto")
        
        let search = Search(query: "lord", unique: .prints)
        Datatank.search(search, resultHandler: { (result) in
            XCTAssert(result.data.count == 175)
            XCTAssert(result.data[0].name == "Abhorrent Overlord")
            XCTAssert(result.data[0].rarity == Rarity.rare)
            expectation.fulfill()
        }) { (resultError) in
            XCTFail()
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testUniqueArt() {
        let expectation = self.expectation(description: "Search database sorted by rarity, auto")
        
        let search = Search(query: "lord", unique: .art)
        Datatank.search(search, resultHandler: { (result) in
            XCTAssert(result.data.count == 97)
            XCTAssert(result.data[0].name == "Abhorrent Overlord")
            XCTAssert(result.data[0].rarity == Rarity.rare)
            expectation.fulfill()
        }) { (resultError) in
            XCTFail()
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
