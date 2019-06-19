//
//  List.swift
//  CardRef
//
//  Created by Doug Goldstein on 6/15/19.
//  Copyright © 2019 Doug Goldstein. All rights reserved.
//

import Foundation

/// List object.
struct List<DataType: Codable>: Codable {
    //MARK: - Properties
    /// An array of the requested objects, in a specific order.
    let data: [DataType]
    /// True if this List is paginated and there is a page beyond the current page.
    let hasMore: Bool
    /// If there is a page beyond the current page, this field will contain a full API URI to that page. You may submit a HTTP GET request to that URI to continue paginating forward on this List.
    let nextPage: URL?
    /// If this is a list of Card objects, this field will contain the total number of cards found across all pages.
    let totalCards: Int?
    /// An array of human-readable warnings issued when generating this list, as strings. Warnings are non-fatal issues that the API discovered with your input. In general, they indicate that the List will not contain the all of the information you requested. You should fix the warnings and re-submit your request.
    let warnings: [String]?
    
    
    
    //MARK: - Constructors
    /// Decodes a list object.
    ///
    /// - Parameter decoder: The decoder object.
    /// - Throws: DecodingError if invaild value.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let object = try container.decode(String.self, forKey: .object)
        assert(object == "list")
        
        self.data = try container.decode([DataType].self, forKey: .data)
        self.hasMore = try container.decode(Bool.self, forKey: .hasMore)
        self.nextPage = try container.decodeIfPresent(URL.self, forKey: .nextPage)
        self.totalCards = try container.decodeIfPresent(Int.self, forKey: .totalCards)
        self.warnings = try container.decodeIfPresent([String].self, forKey: .warnings)
    }
    
    
    
    //MARK: - Enums
    /// Enum of deserializer keys.
    private enum Keys: String, CodingKey {
        case data
        case hasMore = "has_more"
        case nextPage = "next_page"
        case object
        case totalCards = "total_cards"
        case warnings
    }
}
