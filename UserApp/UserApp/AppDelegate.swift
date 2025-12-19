//
//  AppDelegate.swift
//  UserApp
//
//  Created by Titouan Chauché on 06/10/2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController =
        UINavigationController(rootViewController:HomeViewController())
        window.makeKeyAndVisible()
        Task {
            do {
                let url = URL(string: "http://localhost:3001")!
                let (data, resp) = try await URLSession.shared.data(from: url)
                print("STATUS:", (resp as? HTTPURLResponse)?.statusCode ?? -1)
                print("BODY:", String(data: data, encoding: .utf8) ?? "nil")
            } catch {
                print("API FAIL:", error)
            }
        }

        self.window = window
        
        return true
    }

}

