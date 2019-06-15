//
//  ImageType.swift
//  CardRef
//
//  Created by Doug Goldstein on 6/13/19.
//  Copyright © 2019 Doug Goldstein. All rights reserved.
//

import Foundation

enum ImageType: String, Codable, Hashable
{
    case png = "png"
    case borderCrop = "border_crop"
    case artCrop = "art_crop"
    case large = "large"
    case normal = "normal"
    case small = "small"
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        if let imageType = ImageType(rawValue: raw) {
            self = imageType
        }
        else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid image type value: '\(raw)'")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}
