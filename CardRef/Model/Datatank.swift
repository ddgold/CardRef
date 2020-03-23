//
//  Datatank.swift
//  CardRef
//
//  Created by Doug Goldstein on 6/14/19.
//  Copyright © 2019 Doug Goldstein. All rights reserved.
//

import UIKit
import os.log

/// A singleton datatank object that processes all loading of, and caching of, data from webservices.
struct Datatank {
    //MARK: - Properties
    /// The JSON decoder.
    private static let decoder = JSONDecoder()
    
    /// Cache of individual cards.
    private static var cards = [URL: Card]()
    /// Cache of search results.
    private static var results = [URL: List<Card>]()
    /// Cache of card images.
    private static var images = [URL: UIImage]()
    /// Cache of rulings.
    private static var rulings = [URL: List<Ruling>]()
    
    
    
    //MARK: - Constructors
    /// Private constructor, so there will never an actual instance.
    private init() { }
    
    
    
    //MARK: - Public Functions
    /// Load an individual card via webservice or cache.
    ///
    /// - Parameters:
    ///   - id: The ID of the card to load.
    ///   - resultHandler: The completion handler for when the request returns a result.
    ///   - errorHandler: The completion handler for when the request returns an error.
    static func card(_ id: String, resultHandler: @escaping (Card) -> Void, errorHandler: @escaping (RequestError) -> Void) {
        let url = URL(string: "https://api.scryfall.com/cards/\(id)")!
        // Check cache
        if let card = cards[url] {
            os_log("card cached: %{PUBLIC}@", log: OSLog.datatank, type: .info, url.absoluteString)
            resultHandler(card)
            return
        }
        
        // Else request card from server, asynchronous
        request(url, resultHandler: { (card: Card) in
            os_log("card downloaded: %{PUBLIC}@", log: OSLog.datatank, type: .info, url.absoluteString)
            resultHandler(card)
            cards[url] = card
        }, errorHandler: { (error: RequestError) in
            os_log("card download error: %{PUBLIC}@", log: OSLog.datatank, type: .error, url.absoluteString)
            errorHandler(error)
        })
    }
    
    /// Load multiple cards by ID via webservice or cache.
    ///
    /// - Parameters:
    ///   - id: The ID of the card to load.
    ///   - resultHandler: The completion handler for when the request returns a result.
    ///   - errorHandler: The completion handler for when the request returns an error.
    static func cards(_ ids: [String], resultHandler: @escaping ([Card]) -> Void, errorHandler: @escaping (RequestError) -> Void) {
        var outstanding = ids.count
        var cards = [Card]()
        for id in ids {
            card(id, resultHandler: { (card: Card) in
                outstanding -= 1
                cards.append(card)
                
                if outstanding == 0 {
                    resultHandler(cards)
                }
            }, errorHandler: { (error: RequestError) in
                outstanding -= 1
                errorHandler(error)
                
                if outstanding == 0 {
                    resultHandler(cards)
                }
            })
        }
    }
    
    /// Load an image of a card via webservice or cache
    ///
    /// - Parameters:
    ///   - card: The card.
    ///   - type: The type of image.
    ///   - resultHandler: The completion handler for when the request returns a result.
    ///   - errorHandler: The completion handler for when the request returns an error.
    static func image(_ card: Card, type: ImageType, resultHandler: @escaping (UIImage) -> Void, errorHandler: @escaping (RequestError) -> Void) {
        // Select URl from card
        let url: URL
        if card.layout == .transform {
            url = card.cardFaces![0].imageURLs![type]!
        }
        else {
            url = card.imageURLs![type]!
        }
        
        // Check cache
        if let image = images[url] {
            os_log("image cached: %{PUBLIC}@", log: OSLog.datatank, type: .info, url.absoluteString)
            resultHandler(image)
            return
        }
        
        // Else request card image from server, asynchronous
        request(url, resultHandler: { (image: UIImage) in
            os_log("image downloaded: %{PUBLIC}@", log: OSLog.datatank, type: .info, url.absoluteString)
            resultHandler(image)
            images[url] = image
        }, errorHandler: { (error: RequestError) in
            os_log("image download error: %{PUBLIC}@", log: OSLog.datatank, type: .error, url.absoluteString)
            errorHandler(error)
        })
        
    }
    
    /// Load rulings for a card via webservice or cache.
    ///
    /// - Parameters:
    ///   - card: The card.
    ///   - resultHandler: The completion handler for when the request returns a result.
    ///   - errorHandler: The completion handler for when the request returns an error.
    static func rulings(_ card: Card, resultHandler: @escaping (List<Ruling>) -> Void, errorHandler: @escaping (RequestError) -> Void) {
        // Select URl from card
        let url = card.rulingsURL
        
        // Check cache
        if let rulings = rulings[url] {
            os_log("rulings cached: %{PUBLIC}@", log: OSLog.datatank, type: .info, url.absoluteString)
            resultHandler(rulings)
            return
        }
        
        // Else request rulings from server, asynchronous
        request(url, resultHandler: { (rulings: List<Ruling>) in
            os_log("rulings downloaded: %{PUBLIC}@", log: OSLog.datatank, type: .info, url.absoluteString)
            resultHandler(rulings)
            self.rulings[url] = rulings
        }, errorHandler: { (error: RequestError) in
            os_log("rulings download error: %{PUBLIC}@", log: OSLog.datatank, type: .error, url.absoluteString)
            errorHandler(error)
        })
    }
    
    /// Load first page of a search via webservice or cache.
    ///
    /// - Parameters:
    ///   - search: The search object.
    ///   - resultHandler: The completion handler for when the request returns a result.
    ///   - errorHandler: The completion handler for when the request returns an error.
    static func search(_ search: Search, resultHandler: @escaping (List<Card>) -> Void, errorHandler: @escaping (RequestError) -> Void) {
        // Check cache
        let url = search.url
        if let result = results[url] {
            os_log("search cached: %{PUBLIC}@", log: OSLog.datatank, type: .info, url.absoluteString)
            resultHandler(result)
            return
        }
        
        // Else request list of cards from server, asynchronous
        request(url, resultHandler: { (result: List<Card>) in
            os_log("search downloaded: %{PUBLIC}@", log: OSLog.datatank, type: .info, url.absoluteString)
            resultHandler(result)
            results[url] = result
            for card in result.data {
                cards[card.url] = card
            }
        }, errorHandler: { (error: RequestError) in
            os_log("search download error: %{PUBLIC}@", log: OSLog.datatank, type: .error, url.absoluteString)
            errorHandler(error)
        })
    }
    
    /// Load next page of a search via webservice or cache.
    ///
    /// - Parameters:
    ///   - previous: The previous result object.
    ///   - resultHandler: The completion handler for when the request returns a result.
    ///   - errorHandler: The completion handler for when the request returns an error.
    static func search(_ previous: List<Card>, resultHandler: @escaping (List<Card>) -> Void, errorHandler: @escaping (RequestError) -> Void) {
        // Check cache
        let url = previous.nextPage!
        if let result = results[url] {
            os_log("next page cached: %{PUBLIC}@", log: OSLog.datatank, type: .info, url.absoluteString)
            resultHandler(result)
            return
        }
        
        // Else request list of cards from server, asynchronous
        request(url, resultHandler: { (result: List<Card>) in
            os_log("next page downloaded: %{PUBLIC}@", log: OSLog.datatank, type: .info, url.absoluteString)
            resultHandler(result)
            results[url] = result
            for card in result.data {
                cards[card.url] = card
            }
        }, errorHandler: { (error: RequestError) in
            os_log("next page download error: %{PUBLIC}@", log: OSLog.datatank, type: .error, url.absoluteString)
            errorHandler(error)
        })
    }
    
    /// Print the current status of the datatank for debuging
    static func debugStatus() {
        debugPrint("Datatank Status:")
        debugPrint("- Cards: \(cards.count)")
        debugPrint("- Results: \(results.count)")
        debugPrint("- Images: \(images.count)")
    }
    
    
    
    //MARK: - Private Functions
    /// Request the JSON from a URL.
    ///
    /// - Parameters:
    ///   - url: The URL.
    ///   - resultHandler: The completion handler for when the request returns a result.
    ///   - errorHandler: The completion handler for when the request returns an error.
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
    
    /// Request an image from a URL.
    ///
    /// - Parameters:
    ///   - url: The URL.
    ///   - resultHandler: The completion handler for when the request returns a result.
    ///   - errorHandler: The completion handler for when the request returns an error.
    private static func request(_ url: URL, resultHandler: @escaping (UIImage) -> Void, errorHandler: @escaping (RequestError) -> Void) {
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
                    guard let image = UIImage(data: data) else {
                        fatalError("Data is not a properly formated image.")
                    }
                    resultHandler(image)
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


extension OSLog {
    /// Use bundleIdentifier as subsystem.
    private static var subsystem = Bundle.main.bundleIdentifier!
    
    /// A datatank log.
    static let datatank = OSLog(subsystem: subsystem, category: "datatank")
}
