//
//  RequestError.swift
//  CardRef
//
//  Created by Doug Goldstein on 6/16/19.
//  Copyright © 2019 Doug Goldstein. All rights reserved.
//

import Foundation

/// Request error object.
struct RequestError: Codable {
    //MARK: - Properties
    /// A computer-friendly string representing the appropriate HTTP status code.
    let code: String
    /// An integer HTTP status code for this error.
    let status: Int
    /// A human-readable string explaining the error.
    let details: String
    /// A computer-friendly string that provides additional context for the main error. For example, an endpoint many generate HTTP 404 errors for different kinds of input. This field will provide a label for the specific kind of 404 failure, such as ambiguous.
    let type: String?
    /// If your input also generated non-failure warnings, they will be provided as human-readable strings in this array.
    let warnings: [String]?
    
    
    
    //MARK: - Constructors
    /// Decodes a request error object.
    ///
    /// - Parameter decoder: The decoder object.
    /// - Throws: DecodingError if invaild value.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let object = try container.decode(String.self, forKey: .object)
        assert(object == "error")
        
        self.code = try container.decode(String.self, forKey: .code)
        self.status = try container.decode(Int.self, forKey: .status)
        self.details = try container.decode(String.self, forKey: .details)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.warnings = try container.decodeIfPresent([String].self, forKey: .warnings)
    }
    
    
    
    //MARK: - Public Functions
    /// Helper function for turning request error into a fatal error.
    func fatal() {
        fatalError("\(code) [\(status)]: \(details)")
    }
    
    
    
    //MARK: - Enums
    /// Enum of deserializer keys.
    private enum Keys: String, CodingKey {
        case code
        case status
        case object
        case details
        case type
        case warnings
    }
}

