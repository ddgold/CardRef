//
//  AppDelegate.swift
//  CardRef
//
//  Created by Doug Goldstein on 6/11/19.
//  Copyright © 2019 Doug Goldstein. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        // Make and present window with tab bar controller
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = TabBarController()
        window!.makeKeyAndVisible()
        
        return true
    }
}

