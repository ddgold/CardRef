//
//  Datatank.swift
//  CardRef
//
//  Created by Doug Goldstein on 6/14/19.
//  Copyright © 2019 Doug Goldstein. All rights reserved.
//

import Foundation

///
/// A singleton datatank object that processes all loading of, and caching of, data from webservices.
///
struct Datatank {
    //MARK: - Properties
    /// The JSON decoder.
    private static let decoder = JSONDecoder()
    
    /// Cache of individual cards
    private static var cards = [URL: Card]()
    /// Cache of search results
    private static var results = [URL: List<Card>]()
    
    
    
    //MARK: - Constructors
    /// Private constructor, so there will never an actual instance.
    private init() { }
    
    
    
    //MARK: - Public Functions
    ///
    /// Load an individual card via webservice or cache.
    ///
    /// - Parameters:
    ///     - id: The ID of the card to load.
    ///     - resultHandler: The completion handler for when the request returns a result.
    ///     - errorHandler: The completion handler for when the request returns an error.
    ///
    static func card(_ id: String, resultHandler: @escaping (Card) -> Void, errorHandler: @escaping (RequestError) -> Void) {
        let url = URL(string: "https://api.scryfall.com/cards/\(id)")!
        // Check cache
        if let card = cards[url]
        {
            resultHandler(card)
            return
        }
        
        // Else request card from server, asynchronous
        request(url, resultHandler: { (card: Card) in
            resultHandler(card)
            cards[url] = card
        }, errorHandler: errorHandler)
    }
    
    ///
    /// Load a new search via webservice or cache.
    ///
    /// - Parameters:
    ///     - query: The search query string.
    ///     - resultHandler: The completion handler for when the request returns a result.
    ///     - errorHandler: The completion handler for when the request returns an error.
    ///
    static func search(_ search: String, resultHandler: @escaping (List<Card>) -> Void, errorHandler: @escaping (RequestError) -> Void) {
        // Check cache
        let escaped = search.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: "https://api.scryfall.com/cards/search?q=\(escaped)")!
        if let result = results[url]
        {
            resultHandler(result)
            return
        }
        
        // Else request list of cards from server, asynchronous
        request(url, resultHandler: { (result: List<Card>) in
            resultHandler(result)
            results[url] = result
            for card in result.data {
                cards[card.url] = card
            }
        }, errorHandler: errorHandler)
    }
    
    ///
    /// Load the next page of a search via webservice or cache.
    ///
    /// - Parameters:
    ///     - previous: The previous result object.
    ///     - resultHandler: The completion handler for when the request returns a result.
    ///     - errorHandler: The completion handler for when the request returns an error.
    ///
    static func nextPage(_ previous: List<Card>, resultHandler: @escaping (List<Card>) -> Void, errorHandler: @escaping (RequestError) -> Void) {
        // Check cache
        let url = previous.nextPage!
        if let result = results[url]
        {
            resultHandler(result)
            return
        }
        
        // Else request list of cards from server, asynchronous
        request(url, resultHandler: { (result: List<Card>) in
            resultHandler(result)
            results[url] = result
            for card in result.data {
                cards[card.url] = card
            }
        }, errorHandler: errorHandler)
    }
    
    /// Print the current status of the datatank for debuging
    static func debugStatus() {
        debugPrint("Datatank Status:")
        debugPrint("- Cards: \(cards.count)")
        debugPrint("- Results: \(results.count)")
    }
    
    
    
    //MARK: - Private Functions
    ///
    /// Request the JSON from a URL.
    ///
    /// - Parameters:
    ///     - url: The URL.
    ///     - resultHandler: The completion handler for when the request returns a result.
    ///     - errorHandler: The completion handler for when the request returns an error.
    ///
    private static func request<ObjectType: Codable>(_ url: URL, resultHandler: @escaping (ObjectType) -> Void, errorHandler: @escaping (RequestError) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                fatalError("URLSession error in request: \(error.localizedDescription)")
            }
            
            guard let data = data else {
                fatalError("No data in request")
            }
            
            guard let response = response as? HTTPURLResponse else {
                fatalError("No response in request")
            }
            
            do {
                if (response.statusCode == 200) {
                    let object = try decoder.decode(ObjectType.self, from: data)
                    resultHandler(object)
                }
                else {
                    let error = try decoder.decode(RequestError.self, from: data)
                    errorHandler(error)
                }
            }
            catch {
                fatalError("Decoder error in request: \(error.localizedDescription)")
            }
        }).resume()
    }
}
