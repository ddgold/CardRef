//
//  TabBarController.swift
//  CardRef
//
//  Created by Doug Goldstein on 6/14/19.
//  Copyright © 2019 Doug Goldstein. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var viewControllers = [UIViewController]()
        
        // Bookmarks view controller
        let bookmarksViewController = BookmarksViewController()
        bookmarksViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)
        viewControllers += [UINavigationController(rootViewController: bookmarksViewController)]
        
        // Search view controller
        let searchViewController = SearchViewController()
        searchViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        viewControllers += [UINavigationController(rootViewController: searchViewController)]
        
        self.viewControllers = viewControllers
        
        // Listen for theme changes
        Theme.subscribe(self, selector: #selector(updateTheme(_:)))
        updateTheme(nil)
    }
    
    
    
    //MARK: - Public Functions
    /// Updates the view to the current theme.
    ///
    /// - Parameters:
    ///   - notification: Unused.
    @objc func updateTheme(_: Notification?) {
        self.tabBar.tintColor = Theme.tintColor
        self.viewControllers?.forEach({ (viewController) in
            (viewController as! UINavigationController).navigationBar.tintColor = Theme.tintColor
        })
    }
}
