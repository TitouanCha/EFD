//
//  AppDelegate.swift
//  AdminApp
//
//  Created by Titouan Chauché on 06/10/2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        if(UserDefaults.standard.string(forKey: "API_TOKEN") != nil) {
            window.rootViewController =
            UINavigationController(rootViewController:DashBoardViewController())
        }else {
            window.rootViewController =
            UINavigationController(rootViewController:HomeViewController())
        }
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }

}

