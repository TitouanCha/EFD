//
//  HomeViewController.swift
//  UserApp
//
//  Created by Titouan Chauché on 06/10/2025.
//

import UIKit

final class HomeViewController: UIViewController {

    @IBOutlet weak var trackingButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        trackingButton.setTitle(String?("Suivre un colis"), for: .normal)
        if AuthStore.shared.token != nil {
            loginButton.setTitle(String?("Client Area"), for: .normal)
        } else {
            loginButton.setTitle(String?("Connexion"), for: .normal)
        }
    }

    @IBAction func didTapTracking(_ sender: Any) {
        navigationController?.pushViewController(TrackingViewController(), animated: true)
    }

    @IBAction func didTapLogin(_ sender: Any) {
        if AuthStore.shared.token == nil {
                navigationController?.pushViewController(LoginViewController(), animated: true)
            } else {
                navigationController?.pushViewController(ClientAreaViewController(), animated: true)
            }
    }
}
