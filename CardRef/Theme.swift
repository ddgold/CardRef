//
//  Theme.swift
//  CardRef
//
//  Created by Doug Goldstein on 6/23/19.
//  Copyright © 2019 Doug Goldstein. All rights reserved.
//

import UIKit

enum Theme: Equatable {
    case black
    case white
    
    static var current: Theme = .white
    
    /// Color for the tints.
    static var tintColor: UIColor {
        switch Theme.current {
        case .black:
            return .orange
        case .white:
            return .blue
        }
    }
    
    /// Style for all bars, navigator and tab.
    static var barStyle: UIBarStyle {
        switch Theme.current {
        case .black:
            return .black
        case .white:
            return .default
        }
    }
    
    /// Color for the background.
    static var backgroundColor: UIColor {
        switch Theme.current {
        case .black:
            return .black
        case .white:
            return .white
        }
    }
    
    /// Color for the forgound.
    static var foregroundColor: UIColor {
        switch Theme.current {
        case .black:
            return UIColor(white: 0.1, alpha: 1)
        case .white:
            return UIColor(white: 0.9, alpha: 1)
        }
    }
    
    /// Color for the text.
    static var textColor: UIColor {
        switch Theme.current {
        case .black:
            return .white
        case .white:
            return .black
        }
    }
    
    static func subscribe(_ subscriber: Any, selector: Selector) {
        NotificationCenter.default.addObserver(subscriber, selector: selector, name: .themeChange, object: nil)
    }
}

extension Notification.Name {
    static let themeChange = Notification.Name("com.ddgold.CardRef.notifications.themeChange")
}
