//
//  AppDelegate.swift
//  DelivererApp
//
//  Created by Titouan Chauché on 06/10/2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        supportedInterfaceOrientationsFor window: UIWindow?
    ) -> UIInterfaceOrientationMask {
        return .portrait
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)

        if SessionManager.shared.isLoggedIn {
            let homeVC = HomeViewController(
                nibName: "HomeViewController",
                bundle: nil
            )
            let nav = UINavigationController(rootViewController: homeVC)
            window?.rootViewController = nav
        } else {
            let loginVC = LoginViewController(
                nibName: "LoginViewController",
                bundle: nil
            )
            window?.rootViewController = loginVC
        }

        window?.makeKeAndVisible()
        return true
    }
}



