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
    func testRagingGoblin() throws {
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
    
    func testBushiTenderfoot() throws {
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
    
    func testInvalidCard() throws {
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
    
    //MARK: - Search
    func testSearchGoblin() throws {
        let expectation = self.expectation(description: "Search database for 'goblin'")
        
        let search = "goblin"
        Datatank.search(search, resultHandler: { (result) in
            XCTAssert(result.data.count == 175)
            XCTAssert(result.hasMore == true)
            XCTAssert(result.nextPage == URL(string: "https://api.scryfall.com/cards/search?format=json&include_extras=false&include_multilingual=false&order=name&page=2&q=goblin&unique=cards")!)
            XCTAssert(result.totalCards == 195)
            XCTAssert(result.warnings == nil)
            
            Datatank.nextPage(result, resultHandler: { (result) in
                XCTAssert(result.data.count == 20)
                XCTAssert(result.hasMore == false)
                XCTAssert(result.nextPage == nil)
                XCTAssert(result.totalCards == 195)
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
    
    func testSearchFoot() throws {
        let expectation = self.expectation(description: "Search database for 'foot'")
        
        let search = "foot"
        Datatank.search(search, resultHandler: { (result) in
            XCTAssert(result.data.count == 25)
            XCTAssert(result.hasMore == false)
            XCTAssert(result.nextPage == nil)
            XCTAssert(result.totalCards == 25)
            XCTAssert(result.warnings == nil)
            
            expectation.fulfill()
        }, errorHandler: { (requestError) in
            XCTFail()
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
