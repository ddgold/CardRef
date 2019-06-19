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
    }
    

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
