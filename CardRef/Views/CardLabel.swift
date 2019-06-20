//
//  CardLabel.swift
//  CardRef
//
//  Created by Doug Goldstein on 6/18/19.
//  Copyright © 2019 Doug Goldstein. All rights reserved.
//

import UIKit

class CardLabel: UILabel {
    //MARK: - Properties
    /// The label's default style. Text within parentheses will have italic style regardless.
    var style: Style
    /// The label's text size.
    var textSize: CGFloat
    /// Whether or not the text should be highlight the tint color, or just default font color.
    var highlight: Bool
    /// Whether or not the text should span multiple lines, or just one line.
    var multiLine: Bool {
        didSet {
            self.numberOfLines = (multiLine ? 0 : 1)
        }
    }
    
    /// The labels text, calls process on setting.
    override var text: String? {
        didSet {
            if let text = text, !text.isEmpty {
                let processedText = process(text: text, font: font())
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.paragraphSpacing = 5
                processedText.addAttribute(.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, processedText.length))
                self.attributedText = processedText
            }
        }
    }
    
    /// Static dictionary mapping token strings to icon file names.
    private static let icons = [
        "∞": "∞.png",
        "0": "0.png",
        "1": "1.png",
        "2": "2.png",
        "2/B": "2B.png",
        "2/G": "2G.png",
        "2/R": "2R.png",
        "2/U": "2U.png",
        "2/W": "2W.png",
        "3": "3.png",
        "4": "4.png",
        "5": "5.png",
        "6": "6.png",
        "7": "7.png",
        "8": "8.png",
        "9": "9.png",
        "10": "10.png",
        "11": "11.png",
        "12": "12.png",
        "13": "13.png",
        "14": "14.png",
        "15": "15.png",
        "16": "16.png",
        "17": "17.png",
        "18": "18.png",
        "19": "19.png",
        "20": "20.png",
        "100": "100.png",
        "1000000": "1000000.png",
        "½": "½.png",
        "HR": "½R.png",
        "HW": "½W.png",
        "B": "B.png",
        "B/G": "BG.png",
        "B/P": "BP.png",
        "B/R": "BR.png",
        "C": "C.png",
        "CHAOS": "CHAOS.png",
        "E": "E.png",
        "G": "G.png",
        "G/P": "GP.png",
        "G/U": "GU.png",
        "G/W": "GW.png",
        "P": "P.png",
        "Q": "Q.png",
        "R": "R.png",
        "R/G": "RG.png",
        "R/P": "RP.png",
        "R/W": "RW.png",
        "S": "S.png",
        "T": "T.png",
        "U": "U.png",
        "U/B": "UB.png",
        "U/P": "UP.png",
        "U/R": "UR.png",
        "W": "W.png",
        "W/B": "WB.png",
        "W/P": "WP.png",
        "W/U": "WU.png",
        "X": "X.png",
        "Y": "Y.png",
        "Z": "Z.png"
    ]
    
    
    
    //MARK: - Constructors
    /// Creates a card lable with all default properties.
    init() {
        self.style = .normal
        self.textSize = UIFont.systemFontSize
        self.highlight = false
        self.multiLine = false
        
        super.init(frame: CGRect())
    }
    
    /// Decoder init not implemented.
    ///
    /// - Parameter aDecoder: The decoder.
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Private Functions
    /// Process a string, italicizing strings in round brackets, and iconizing tokens in curly brackers.  Calls self recursively.
    ///
    /// - Parameters:
    ///   - text: The string to process.
    ///   - font: The current active font.
    /// - Returns: The processed string.
    private func process(text: String, font: UIFont) -> NSMutableAttributedString
    {
        let openIndex = min(text.firstIndex(of: "(") ?? text.endIndex, text.firstIndex(of: "{") ?? text.endIndex)
        
        // No more brackets
        if openIndex == text.endIndex {
            return NSMutableAttributedString(string: String(text), attributes: [.font: font])
        }
        
        
        let closeIndex: String.Index
        let result = NSMutableAttributedString()
        
        // Prefix
        if openIndex > text.startIndex {
            let prefix = text.prefix(through: text.index(before: openIndex))
            result.append(NSMutableAttributedString(string: String(prefix), attributes: [.font: font]))
        }
        
        // Round brackets
        if (text[openIndex] == "(") {
            closeIndex = text.firstIndex(of: ")")!
            let italicFont = self.font(style: .italic)
            let subString = text[text.index(after: openIndex)...text.index(before: closeIndex)]
            result.append(NSAttributedString(string: "(", attributes: [.font: italicFont]))
            result.append(process(text: String(subString), font: italicFont))
            result.append(NSAttributedString(string: ")", attributes: [.font: italicFont]))
        }
            
        // Curley brackets
        else {
            closeIndex = text.firstIndex(of: "}")!
            let token = text[text.index(after: openIndex)...text.index(before: closeIndex)]
            result.append(icon(token: String(token)))
        }
        
        // Suffix
        if closeIndex < text.endIndex {
            let suffix = text.suffix(from: text.index(after: closeIndex))
            result.append(process(text: String(suffix), font: font))
        }
        
        return result
    }
    
    /// Replaces token string with corresponding icon in attribured string format.
    ///
    /// - Parameter token: The token string, not including curly brackets.
    /// - Returns: Attributed string of just the icon.
    private func icon(token: String) -> NSAttributedString {
        if CardLabel.icons.keys.contains(token)  {
            let attachment = NSTextAttachment()
            attachment.image = UIImage(named: CardLabel.icons[token]!)
            
            let ratio = attachment.image!.size.width / attachment.image!.size.height
            attachment.bounds = CGRect(x: attachment.bounds.origin.x, y: attachment.bounds.origin.y - (textSize / 10), width: ratio * textSize, height: textSize)
            
            return NSAttributedString(attachment: attachment)
        }
        else {
            fatalError("Failed to Iconize: Unknown token '\(token)'.")
        }
    }
    
    /// Returns the font with current size and style.
    ///
    /// - Returns: The font.
    private func font() -> UIFont {
        return font(style: self.style)
    }
    
    /// Returns the font with current size, but overriding style.
    ///
    /// - Parameter style: The override style.
    /// - Returns: The font.
    private func font(style: Style) -> UIFont {
        switch style {
        case .normal:
            return UIFont.systemFont(ofSize: textSize)
        case .bold:
            return UIFont.boldSystemFont(ofSize: textSize)
        case .italic:
            return UIFont.italicSystemFont(ofSize: textSize)
        }
    }
    
    
    
    //MARK: - Enums
    /// The font style of the label.
    enum Style {
        case normal
        case bold
        case italic
    }
}
