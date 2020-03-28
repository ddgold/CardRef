//
//  Datatank.swift
//  CardRef
//
//  Created by Doug Goldstein on 6/14/19.
//  Copyright © 2019 Doug Goldstein. All rights reserved.
//

import Foundation
import CoreGraphics
import ImageIO
import os.log

/// A singleton datatank object that processes all loading of, and caching of, data from webservices.
struct Datatank {
    //MARK: - Properties
    /// The JSON decoder.
    private static let decoder = JSONDecoder()
    
    /// Cache of individual cards.
    private static var cards = [String: Card]()
    /// Cache of catalog values.
    private static var catalogs = [URL: Catalog]()
    /// Cache of card images.
    private static var images = [URL: CGImage]()
    /// Cache of search results.
    private static var results = [URL: List<Card>]()
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
        // Check cache
        if let card = cards[id] {
            os_log("card cached: %{PUBLIC}@", log: OSLog.datatank, type: .info, id)
            resultHandler(card)
            return
        }
        
        // Else request card from server, asynchronous
        let url = URL(string: "https://api.scryfall.com/cards/\(id)")!
        request(url, resultHandler: { (card: Card) in
            os_log("card downloaded: %{PUBLIC}@", log: OSLog.datatank, type: .info, id)
            resultHandler(card)
            cards[id] = card
        }, errorHandler: { (error: RequestError) in
            os_log("card download error: %{PUBLIC}@", log: OSLog.datatank, type: .error, id)
            errorHandler(error)
        })
    }
    
    /// Load multiple cards by ID via webservice or cache.
    ///
    /// - Parameters:
    ///   - ids: The array of IDs of the cards to load.
    ///   - completionHandler: The completion handler for when all the request have returned either a result or error.
    ///   - errorHandler: The completion handler for when a request returns an error.  This will be called for each error, so may be called multiple times.
    static func cards(_ ids: [String], completionHandler: @escaping ([Card]) -> Void, errorHandler: @escaping (RequestError) -> Void) {
        var outstanding = ids.count
        var cards = [Card]()
        
        for id in ids {
            card(id, resultHandler: { (card: Card) in
                outstanding -= 1
                cards.append(card)
                
                if outstanding == 0 {
                    completionHandler(cards)
                }
            }, errorHandler: { (error: RequestError) in
                outstanding -= 1
                errorHandler(error)
                
                if outstanding == 0 {
                    completionHandler(cards)
                }
            })
        }
    }
    
    /// Load multiple cards from a .JSON file.
    ///
    /// - Parameter filename: The name of the .JSON file.
    /// - Returns: An array of cards decoded from file.
    static func cards(_ filename: String) -> [Card] {
        let cards: [Card] = load(filename)
        for card in cards {
            os_log("card loaded: %{PUBLIC}@", log: OSLog.datatank, type: .info, card.id)
            self.cards[card.id] = card
        }
        return cards
    }
    
    /// Load a catalog via webservice or cache.
    ///
    /// - Parameters:
    ///   - name: The catalog's name.
    ///   - resultHandler: The completion handler for when the request returns a result.
    ///   - errorHandler: The completion handler for when the request returns an error.
    static func catalog(_ name: Catalog.Name, resultHandler: @escaping (Catalog) -> Void, errorHandler: @escaping (RequestError) -> Void) {
        // Select URl from card
        let url = URL(string: "https://api.scryfall.com/catalog/\(name.rawValue)")!
        
        // Check cache
        if let catalog = catalogs[url] {
            os_log("catalog cached: %{PUBLIC}@", log: OSLog.datatank, type: .info, url.absoluteString)
            resultHandler(catalog)
            return
        }
        
        // Else request rulings from server, asynchronous
        request(url, resultHandler: { (catalog: Catalog) in
            os_log("catalog downloaded: %{PUBLIC}@", log: OSLog.datatank, type: .info, url.absoluteString)
            resultHandler(catalog)
            self.catalogs[url] = catalog
        }, errorHandler: { (error: RequestError) in
            os_log("catalog download error: %{PUBLIC}@", log: OSLog.datatank, type: .error, url.absoluteString)
            errorHandler(error)
        })
    }
    
    /// Load an image of a card via webservice or cache
    ///
    /// - Parameters:
    ///   - card: The card.
    ///   - type: The type of image.
    ///   - resultHandler: The completion handler for when the request returns a result.
    ///   - errorHandler: The completion handler for when the request returns an error.
    static func image(_ card: Card, type: ImageType, resultHandler: @escaping (CGImage) -> Void, errorHandler: @escaping (RequestError) -> Void) {
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
        request(url, resultHandler: { (image: CGImage) in
            os_log("image downloaded: %{PUBLIC}@", log: OSLog.datatank, type: .info, url.absoluteString)
            resultHandler(image)
            images[url] = image
        }, errorHandler: { (error: RequestError) in
            os_log("image download error: %{PUBLIC}@", log: OSLog.datatank, type: .error, url.absoluteString)
            errorHandler(error)
        })
        
    }
    
    /// Load an image from a .png file.
    ///
    /// - Parameter filename: The name of the .png file.
    /// - Returns: The image.
    static func image(_ filename: String) -> CGImage {
        os_log("image loaded: %{PUBLIC}@", log: OSLog.datatank, type: .info, "\(filename).png")
        return load(filename)
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
                cards[card.id] = card
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
                cards[card.id] = card
            }
        }, errorHandler: { (error: RequestError) in
            os_log("next page download error: %{PUBLIC}@", log: OSLog.datatank, type: .error, url.absoluteString)
            errorHandler(error)
        })
    }
    
    /// Print the current status of the datatank for debuging
    static func debugStatus() -> String {
        return "Datatank Status:\n- Cards: \(cards.count)\n- Catalogs: \(catalogs.count)\n- Images: \(images.count)\n- Results: \(results.count)\n- Rulings: \(rulings.count)"
    }
    
    
    
    //MARK: - Private Functions
    /// Request JSON from a URL.
    ///
    /// - Parameters:
    ///   - url: The URL.
    ///   - resultHandler: The completion handler for when the request returns a result.
    ///   - errorHandler: The completion handler for when the request returns an error.
    private static func request<ObjectType: Decodable>(_ url: URL, resultHandler: @escaping (ObjectType) -> Void, errorHandler: @escaping (RequestError) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                fatalError("URLSession error in request: \(url) - \(error.localizedDescription)")
            }
            
            guard let data = data else {
                fatalError("No data in request: \(url)")
            }
            
            guard let response = response as? HTTPURLResponse else {
                fatalError("No response in request: \(url)")
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
                fatalError("Decoder error in request: \(url) - \(error.localizedDescription)")
            }
        }).resume()
    }
    
    /// Load an image from a URL.
    ///
    /// - Parameters:
    ///   - url: The URL.
    ///   - resultHandler: The completion handler for when the request returns a result.
    ///   - errorHandler: The completion handler for when the request returns an error.
    private static func request(_ url: URL, resultHandler: @escaping (CGImage) -> Void, errorHandler: @escaping (RequestError) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                fatalError("URLSession error in request: \(url) - \(error.localizedDescription)")
            }
            
            guard let data = data else {
                fatalError("No data in request: \(url)")
            }
            
            guard let response = response as? HTTPURLResponse else {
                fatalError("No response in request: \(url)")
            }
            
            do {
                if (response.statusCode == 200) {
                    guard
                        let imageSource = CGImageSourceCreateWithData(data as CFData, nil),
                        let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
                    else {
                        fatalError("Improperly formated image data in request: \(url)")
                    }
                    resultHandler(image)
                }
                else {
                    let error = try decoder.decode(RequestError.self, from: data)
                    errorHandler(error)
                }
            }
            catch {
                fatalError("Decoder error in request: \(url) - \(error.localizedDescription)")
            }
        }).resume()
    }
    
    /// Load an object from a .JSON file.
    ///
    /// - Parameters:
    ///   - url: The name of the .JSON file.
    /// - Returns: The decoded JSON object.
    private static func load<ObjectType: Decodable>(_ filename: String) -> ObjectType {
        let data: Data
        
        guard let file = Bundle.main.url(forResource: filename, withExtension: ".json") else {
            fatalError("File not found in load: \(filename)")
        }
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Data error in load: \(filename) - \(error)")
        }
        
        do {
            return try JSONDecoder().decode(ObjectType.self, from: data)
        } catch {
            fatalError("Invalid JSON in load: \(filename) - \(ObjectType.self) - \(error)")
        }
    }
    
    /// Load an image from a .png file.
    ///
    /// - Parameters:
    ///   - url: The name of the .png file.
    /// - Returns: The image.
    private static func load(_ filename: String) -> CGImage {
        let data: Data
        
        guard let file = Bundle.main.url(forResource: filename, withExtension: ".png") else {
            fatalError("File not found in load: \(filename)")
        }
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Data error in load: \(filename) - \(error)")
        }
        guard
            let imageSource = CGImageSourceCreateWithData(data as CFData, nil),
            let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
        else {
            fatalError("Improperly formated image data in load: \(filename)")
        }
        
        return image
    }
}


extension OSLog {
    /// Use bundleIdentifier as subsystem.
    private static var subsystem = Bundle.main.bundleIdentifier!
    
    /// A datatank log.
    static let datatank = OSLog(subsystem: subsystem, category: "datatank")
}
