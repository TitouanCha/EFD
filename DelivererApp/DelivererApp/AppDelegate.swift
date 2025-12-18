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
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)

        let rootVC: UIViewController

        if SessionManager.shared.isLoggedIn {
            rootVC = HomeViewController(
                nibName: "HomeViewController",
                bundle: nil
            )
        } else {
            rootVC = LoginViewController(
                nibName: "LoginViewController",
                bundle: nil
            )
        }

        let nav = UINavigationController(rootViewController: rootVC)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()

        return true
    }
}



