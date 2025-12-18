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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func seeToursTapped(_ sender: UIButton) {
            let vc = ToursViewController(nibName: "ToursViewController", bundle: nil)
            navigationController?.pushViewController(vc, animated: true)
        }

    @IBAction func logoutTapped(_ sender: UIButton) {
        SessionManager.shared.token = nil
        goToLogin()
    }
    private func goToLogin() {
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true)
    }
}

