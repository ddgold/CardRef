//
//  Card.swift
//  CardRef
//
//  Created by Doug Goldstein on 6/11/19.
//  Copyright © 2019 Doug Goldstein. All rights reserved.
//

import Foundation

/// Card object.
struct Card: Codable {
    //MARK: - Properties
    //MARK: Core
    /// This card’s Arena ID, if any. A large percentage of cards are not available on Arena and do not have this ID.
    let arenaID: Int?
    /// A unique ID for this card in Scryfall’s database.
    let id: String
    /// A language code for this printing.
    let lang: String
    /// This card’s Magic Online ID (also known as the Catalog ID), if any. A large percentage of cards are not available on Magic Online and do not have this ID.
    let mtgoID: Int?
    /// This card’s foil Magic Online ID (also known as the Catalog ID), if any. A large percentage of cards are not available on Magic Online and do not have this ID.
    let mtgoFoilID: Int?
    /// This card’s multiverse IDs on Gatherer, if any, as an array of integers. Note that Scryfall includes many promo cards, tokens, and other esoteric objects that do not have these identifiers.
    let multiverseIDs: [Int]?
    /// This card’s ID on TCGplayer’s API, also known as the productId.
    let tcgplayerID: Int?
    /// A unique ID for this card’s oracle identity. This value is consistent across reprinted card editions, and unique among different cards with the same name (tokens, Unstable variants, etc).
    let oracleID: String
    /// URL    A link to where you can begin paginating all re/prints for this card on Scryfall’s API.
    let printsSearchURL: URL
    /// A link to this card’s rulings list on Scryfall’s API.
    let rulingsURL: URL
    /// URL    A link to this card’s permapage on Scryfall’s website.
    let scryfallURL: URL
    /// A link to this card object on Scryfall’s API.
    let url: URL
    
    //MARK: Gameplay
    /// If this card is closely related to other cards, this property will be an array with Related Card Objects.
    let allParts: [Related]?
    /// An array of Card Face objects, if this card is multifaced.
    let cardFaces: [Face]?
    /// The card’s converted mana cost. Note that some funny cards have fractional mana costs.
    let cmc: Decimal
    /// This card’s colors, if the overall card has colors defined by the rules. Otherwise the colors will be on the card_faces objects, see below.
    let colors: [Color]?
    /// This card’s color identity.
    let colorIdentity: [Color]
    /// The colors in this card’s color indicator, if any. A null value for this field indicates the card does not have one.
    let colorIndicator: [Color]?
    /// This card’s overall rank/popularity on EDHREC. Not all cards are ranked.
    let edhrecRank: Int?
    /// True if this printing exists in a foil version.
    let foil: Bool
    /// This card’s hand modifier, if it is Vanguard card. This value will contain a delta, such as -1.
    let handModifier: String?
    /// A code for this card’s layout.
    let layout: Layout
    /// An object describing the legality of this card across play formats. Possible legalities are legal, not_legal, restricted, and banned.
    let legalities: [String: Legality]
    /// This card’s life modifier, if it is Vanguard card. This value will contain a delta, such as +2.
    let lifeModifier: String?
    /// This loyalty if any. Note that some cards have loyalties that are not numeric, such as X.
    let loyalty: String?
    /// The mana cost for this card. This value will be any empty string "" if the cost is absent. Remember that per the game rules, a missing mana cost and a mana cost of {0} are different values. Multi-faced cards will report this value in card faces.
    let manaCost: String?
    /// The name of this card. If this card has multiple faces, this field will contain both names separated by ␣//␣.
    let name: String
    /// True if this printing exists in a nonfoil version.
    let nonfoil: Bool
    /// The Oracle text for this card, if any.
    let oracleText: String?
    /// True if this card is oversized.
    let oversized: Bool
    /// This card’s power, if any. Note that some cards have powers that are not numeric, such as *.
    let power: String?
    /// True if this card is on the Reserved List.
    let reserved: Bool
    /// This card’s toughness, if any. Note that some cards have toughnesses that are not numeric, such as *.
    let toughness: String?
    /// The type line of this card.
    let typeLine: String
    
    //MARK: Print
    /// The name of the illustrator of this card. Newly spoiled cards may not have this field yet.
    let artist: String?
    /// Whether this card is found in boosters.
    let booster: Bool
    /// This card’s border color: black, borderless, gold, silver, or white.
    let borderColor: String
    /// The Scryfall ID for the card back design present on this card.
    let cardBackID: String
    /// This card’s collector number. Note that collector numbers can contain non-numeric characters, such as letters or ★.
    let collectorNumber: String
    /// True if this is a digital card on Magic Online.
    let digital: Bool
    /// The flavor text, if any.
    let flavorText: String?
    /// This card’s frame effect, if any.
    let frameEffects: [FrameEffect]?
    /// This card’s frame layout.
    let frame: FrameType
    /// True if this card’s artwork is larger than normal.
    let fullArt: Bool
    /// A list of games that this card print is available in, paper, arena, and/or mtgo.
    let games: [String]
    /// True if this card’s imagery is high resolution.
    let highresImage: Bool
    /// A unique identifier for the card artwork that remains consistent across reprints. Newly spoiled cards may not have this field yet.
    let illustrationID: String?
    /// An object listing available imagery for this card. See the Card Imagery article for more information.
    let imageURLs: [ImageType: URL]?
    /// An object containing daily price information for this card, including usd, usd_foil, eur, and tix prices, as strings.
    let prices: [String: String?]
    /// The localized name printed on this card, if any.
    let printedName: String?
    /// The localized text printed on this card, if any.
    let printedText: String?
    /// The localized type line printed on this card, if any.
    let printedTypeLine: String?
    /// True if this card is a promotional print.
    let promo: Bool
    /// An array of strings describing what categories of promo cards this card falls into.
    let promoTypes: [String]?
    /// An object providing URIs to this card’s listing on major marketplaces.
    let purchaseURLs: [String: URL]
    /// This card’s rarity. One of common, uncommon, rare, or mythic.
    let rarity: Rarity
    /// An object providing URIs to this card’s listing on other Magic: The Gathering online resources.
    let relatedURLs: [String: URL]
    /// The date this card was first released.
    let releasedAt: String
    /// True if this card is a reprint.
    let reprint: Bool
    /// A link to this card’s set on Scryfall’s website.
    let scryfallSetURL: URL
    /// This card’s full set name.
    let setName: String
    /// A link to where you can begin paginating this card’s set on the Scryfall API.
    let setSearchURL: URL
    /// The type of set this printing is in.
    let setType: String
    /// A link to this card’s set object on Scryfall’s API.
    let setURL: URL
    /// This card’s set code.
    let set: String
    /// True if this card is a Story Spotlight.
    let storySpotlight: Bool
    /// True if the card is printed without text.
    let textless: Bool
    /// Whether this card is a variation of another printing.
    let variation: Bool
    /// The printing ID of the printing this card is a variation of.
    let variationOf: String?
    /// This card’s watermark, if any.
    let watermark: String?
    
    
    
    //MARK: Constructors
    /// Decodes a card object.
    ///
    /// - Parameter decoder: The decoder object.
    /// - Throws: DecodingError if invaild value.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let object = try container.decode(String.self, forKey: .object)
        assert(object == "card")
        
        // Core
        self.arenaID = try container.decodeIfPresent(Int.self, forKey: .arenaID)
        self.id = try container.decode(String.self, forKey: .id)
        self.lang = try container.decode(String.self, forKey: .lang)
        self.mtgoID = try container.decodeIfPresent(Int.self, forKey: .mtgoID)
        self.mtgoFoilID = try container.decodeIfPresent(Int.self, forKey: .mtgoFoilID)
        self.multiverseIDs = try container.decodeIfPresent([Int].self, forKey: .multiverseIDs)
        self.tcgplayerID = try container.decodeIfPresent(Int.self, forKey: .tcgplayerID)
        self.oracleID = try container.decode(String.self, forKey: .oracleID)
        self.printsSearchURL = try container.decode(URL.self, forKey: .printsSearchURL)
        self.rulingsURL = try container.decode(URL.self, forKey: .rulingsURL)
        self.scryfallURL = try container.decode(URL.self, forKey: .scryfallURL)
        self.url = try container.decode(URL.self, forKey: .url)
        
        // Gameplay
        self.allParts = try container.decodeIfPresent([Related].self, forKey: .allParts)
        self.cardFaces = try container.decodeIfPresent([Face].self, forKey: .cardFaces)
        self.cmc = try container.decode(Decimal.self, forKey: .cmc)
        self.colors = try container.decodeIfPresent([Color].self, forKey: .colors)
        self.colorIdentity = try container.decode([Color].self, forKey: .colorIdentity)
        self.colorIndicator = try container.decodeIfPresent([Color].self, forKey: .colorIndicator)
        self.edhrecRank = try container.decodeIfPresent(Int.self, forKey: .edhrecRank)
        self.foil = try container.decode(Bool.self, forKey: .foil)
        self.handModifier = try container.decodeIfPresent(String.self, forKey: .handModifier)
        self.layout = try container.decode(Layout.self, forKey: .layout)
        self.legalities = try container.decode([String: Legality].self, forKey: .legalities)
        self.lifeModifier = try container.decodeIfPresent(String.self, forKey: .lifeModifier)
        self.loyalty = try container.decodeIfPresent(String.self, forKey: .loyalty)
        self.manaCost = try container.decodeIfPresent(String.self, forKey: .manaCost)
        self.name = try container.decode(String.self, forKey: .name)
        self.nonfoil = try container.decode(Bool.self, forKey: .nonfoil)
        self.oracleText = try container.decodeIfPresent(String.self, forKey: .oracleText)
        self.oversized = try container.decode(Bool.self, forKey: .oversized)
        self.power = try container.decodeIfPresent(String.self, forKey: .power)
        self.reserved = try container.decode(Bool.self, forKey: .reserved)
        self.toughness = try container.decodeIfPresent(String.self, forKey: .toughness)
        self.typeLine = try container.decode(String.self, forKey: .typeLine)
        
        // Print
        self.artist = try container.decodeIfPresent(String.self, forKey: .artist)
        self.booster = try container.decode(Bool.self, forKey: .booster)
        self.borderColor = try container.decode(String.self, forKey: .borderColor)
        self.cardBackID = try container.decode(String.self, forKey: .cardBackID)
        self.collectorNumber = try container.decode(String.self, forKey: .collectorNumber)
        self.digital = try container.decode(Bool.self, forKey: .digital)
        self.flavorText = try container.decodeIfPresent(String.self, forKey: .flavorText)
        self.frameEffects = try container.decodeIfPresent([FrameEffect].self, forKey: .frameEffects)
        self.frame = try container.decode(FrameType.self, forKey: .frame)
        self.fullArt = try container.decode(Bool.self, forKey: .fullArt)
        self.games = try container.decode([String].self, forKey: .games)
        self.highresImage = try container.decode(Bool.self, forKey: .highresImage)
        self.illustrationID = try container.decodeIfPresent(String.self, forKey: .illustrationID)
        if let strings = try container.decodeIfPresent([String: URL].self, forKey: .imageURLs) {
            var imageTypes = [ImageType: URL]()
            for (key, value) in strings {
                imageTypes[ImageType(rawValue: key)!] = value
            }
            self.imageURLs = imageTypes
        }
        else {
            self.imageURLs = nil
        }
        self.prices = try container.decode([String: String?].self, forKey: .prices)
        self.printedName = try container.decodeIfPresent(String.self, forKey: .printedName)
        self.printedText = try container.decodeIfPresent(String.self, forKey: .printedText)
        self.printedTypeLine = try container.decodeIfPresent(String.self, forKey: .printedTypeLine)
        self.promo = try container.decode(Bool.self, forKey: .promo)
        self.promoTypes = try container.decodeIfPresent([String].self, forKey: .promoTypes)
        self.purchaseURLs = try container.decode([String: URL].self, forKey: .purchaseURLs)
        self.rarity = try container.decode(Rarity.self, forKey: .rarity)
        self.relatedURLs = try container.decode([String: URL].self, forKey: .relatedURLs)
        self.releasedAt = try container.decode(String.self, forKey: .releasedAt)
        self.reprint = try container.decode(Bool.self, forKey: .reprint)
        self.scryfallSetURL = try container.decode(URL.self, forKey: .scryfallSetURL)
        self.setName = try container.decode(String.self, forKey: .setName)
        self.setSearchURL = try container.decode(URL.self, forKey: .setSearchURL)
        self.setType = try container.decode(String.self, forKey: .setType)
        self.setURL = try container.decode(URL.self, forKey: .setURL)
        self.set = try container.decode(String.self, forKey: .set)
        self.storySpotlight = try container.decode(Bool.self, forKey: .storySpotlight)
        self.textless = try container.decode(Bool.self, forKey: .textless)
        self.variation = try container.decode(Bool.self, forKey: .variation)
        self.variationOf = try container.decodeIfPresent(String.self, forKey: .variationOf)
        self.watermark = try container.decodeIfPresent(String.self, forKey: .watermark)
    }
    
    
    
    //MARK: Enums
    /// Enum of deserializer keys.
    private enum Keys: String, CodingKey {
        // Core
        case arenaID = "arena_id"
        case id
        case lang
        case mtgoID = "mtgo_id"
        case mtgoFoilID = "mtgo_foil_id"
        case multiverseIDs = "multiverse_ids"
        case tcgplayerID = "tcgplayer_id"
        case object
        case oracleID = "oracle_id"
        case printsSearchURL = "prints_search_uri"
        case rulingsURL = "rulings_uri"
        case scryfallURL = "scryfall_uri"
        case url = "uri"
        
        // Gameplay
        case allParts = "all_parts"
        case cardFaces = "card_faces"
        case cmc
        case colors
        case colorIdentity = "color_identity"
        case colorIndicator = "color_indicator"
        case edhrecRank = "edhrec_rank"
        case foil
        case handModifier = "hand_modifier"
        case layout
        case legalities
        case lifeModifier = "life_modifier"
        case loyalty
        case manaCost = "mana_cost"
        case name
        case nonfoil
        case oracleText = "oracle_text"
        case oversized
        case power
        case reserved
        case toughness
        case typeLine = "type_line"
        
        // Print
        case artist
        case booster
        case borderColor = "border_color"
        case cardBackID = "card_back_id"
        case collectorNumber = "collector_number"
        case digital
        case flavorText = "flavor_text"
        case frameEffects = "frame_effects"
        case frame
        case fullArt = "full_art"
        case games
        case highresImage = "highres_image"
        case illustrationID = "illustration_id"
        case imageURLs = "image_uris"
        case prices
        case printedName = "printed_name"
        case printedText = "printed_text"
        case printedTypeLine = "printed_type_line"
        case promo
        case promoTypes = "promo_types"
        case purchaseURLs = "purchase_uris"
        case rarity
        case relatedURLs = "related_uris"
        case releasedAt = "released_at"
        case reprint
        case scryfallSetURL = "scryfall_set_uri"
        case setName = "set_name"
        case setSearchURL = "set_search_uri"
        case setType = "set_type"
        case setURL = "set_uri"
        case set
        case storySpotlight = "story_spotlight"
        case textless
        case variation
        case variationOf = "variation_of"
        case watermark
    }
    
    
    
    //MARK: - Card Face
    /// Card face object.
    struct Face: Codable
    {
        //MARK: Properties
        /// The name of the illustrator of this card face. Newly spoiled cards may not have this field yet.
        let artist: String?
        /// The colors in this face’s color indicator, if any.
        let colorIndicator: [Color]?
        /// This face’s colors, if the game defines colors for the individual face of this card
        let colors: [Color]?
        /// The flavor text printed on this face, if any.
        let flavorText: String?
        /// A unique identifier for the card face artwork that remains consistent across reprints. Newly spoiled cards may not have this field yet.
        let illustrationID: String?
        /// An object providing URIs to imagery for this face, if this is a double-sided card. If this card is not double-sided, then the image_uris property will be part of the parent object instead.
        let imageURLs: [ImageType: URL]?
        /// This face’s loyalty, if any.
        let loyalty: String?
        /// The mana cost for this face. This value will be any empty string "" if the cost is absent. Remember that per the game rules, a missing mana cost and a mana cost of {0} are different values.
        let manaCost: String?
        /// The name of this particular face.
        let name: String
        /// The Oracle text for this face, if any.
        let oracleText: String?
        /// This face’s power, if any. Note that some cards have powers that are not numeric, such as *.
        let power: String?
        /// The localized name printed on this face, if any.
        let printedName: String?
        /// The localized text printed on this face, if any.
        let printedText: String?
        /// The localized type line printed on this face, if any.
        let printedTypeLine: String?
        /// This face’s toughness, if any.
        let toughness: String?
        /// The type line of this particular face.
        let typeLine: String
        /// The watermark on this particulary card face, if any.
        let watermark: String?
        
        
        
        //MARK: Constructors
        /// Decodes a card face object.
        ///
        /// - Parameter decoder: The decoder object.
        /// - Throws: DecodingError if invaild value.
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: Keys.self)
            let object = try container.decode(String.self, forKey: .object)
            assert(object == "card_face")
            
            self.artist = try container.decodeIfPresent(String.self, forKey: .artist)
            self.colorIndicator = try container.decodeIfPresent([Color].self, forKey: .colorIndicator)
            self.colors = try container.decodeIfPresent([Color].self, forKey: .colors)
            self.flavorText = try container.decodeIfPresent(String.self, forKey: .flavorText)
            self.illustrationID = try container.decodeIfPresent(String.self, forKey: .illustrationID)
            if let strings = try container.decodeIfPresent([String: URL].self, forKey: .imageURLs) {
                var imageTypes = [ImageType: URL]()
                for (key, value) in strings {
                    imageTypes[ImageType(rawValue: key)!] = value
                }
                self.imageURLs = imageTypes
            }
            else {
                self.imageURLs = nil
            }
            self.loyalty = try container.decodeIfPresent(String.self, forKey: .loyalty)
            self.manaCost = try container.decodeIfPresent(String.self, forKey: .manaCost)
            self.name = try container.decode(String.self, forKey: .name)
            self.oracleText = try container.decodeIfPresent(String.self, forKey: .oracleText)
            self.power = try container.decodeIfPresent(String.self, forKey: .power)
            self.printedName = try container.decodeIfPresent(String.self, forKey: .printedName)
            self.printedText = try container.decodeIfPresent(String.self, forKey: .printedText)
            self.printedTypeLine = try container.decodeIfPresent(String.self, forKey: .printedTypeLine)
            self.toughness = try container.decodeIfPresent(String.self, forKey: .toughness)
            self.typeLine = try container.decode(String.self, forKey: .typeLine)
            self.watermark = try container.decodeIfPresent(String.self, forKey: .watermark)
        }
        
        
        
        //MARK: Enums
        /// Enum of deserializer keys.
        private enum Keys: String, CodingKey {
            case artist
            case colorIndicator = "color_indicator"
            case colors
            case flavorText = "flavor_text"
            case illustrationID = "illustration_id"
            case imageURLs = "image_uris"
            case loyalty
            case manaCost = "mana_cost"
            case name
            case object
            case oracleText = "oracle_text"
            case power
            case printedName = "printed_name"
            case printedText = "printed_text"
            case printedTypeLine = "printed_type_line"
            case toughness
            case typeLine = "type_line"
            case watermark
        }
    }
    
    
    
    //MARK: - Related Card
    /// Related card object.
    struct Related: Codable
    {
        //MARK: Properties
        /// An unique ID for this card in Scryfall’s database.
        let id: String
        /// A field explaining what role this card plays in this relationship, one of token, meld_part, meld_result, or combo_piece.
        let component: RelatedType
        /// The name of this particular related card.
        let name: String
        /// The type line of this card.
        let typeLine: String
        /// A URI where you can retrieve a full object describing this card on Scryfall’s API.
        let uri: URL
        
        
        
        //MARK: Constructors
        /// Decodes a related card object.
        ///
        /// - Parameter decoder: The decoder object.
        /// - Throws: DecodingError if invaild value.
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: Keys.self)
            let object = try container.decode(String.self, forKey: .object)
            assert(object == "related_card")
            
            self.id = try container.decode(String.self, forKey: .id)
            self.component = try container.decode(RelatedType.self, forKey: .component)
            self.name = try container.decode(String.self, forKey: .name)
            self.typeLine = try container.decode(String.self, forKey: .typeLine)
            self.uri = try container.decode(URL.self, forKey: .uri)
        }
        
        
        
        //MARK: Enums
        /// Enum of deserializer keys.
        private enum Keys: String, CodingKey {
            case id
            case object
            case component
            case name
            case typeLine = "type_line"
            case uri
        }
    }
}
