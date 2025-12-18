//
//  HomeViewController.swift
//  DelivererApp
//
//  Created by Titouan Chauché on 06/10/2025.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var seeToursButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!

    @IBAction func seeToursTapped(_ sender: UIButton) {
        let vc = ToursViewController(
            nibName: "ToursViewController",
            bundle: nil
        )
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func logoutTapped(_ sender: UIButton) {
        SessionManager.shared.logout()

        let loginVC = LoginViewController(
            nibName: "LoginViewController",
            bundle: nil
        )
        navigationController?.setViewControllers([loginVC], animated: true)
    }
}


