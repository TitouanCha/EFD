//
//  LoginViewController.swift
//  DelivererApp
//
//  Created by Hugo Miesch on 18/12/2025.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardOnTap()
    }

    @IBAction func loginTapped(_ sender: UIButton) {
        guard
            let email = emailField.text, !email.isEmpty,
            let password = passwordField.text, !password.isEmpty
        else {
            showAlert(title: "Erreur", message: "Veuillez remplir tous les champs")
            return
        }

        loginButton.isEnabled = false

        AuthAPI.shared.login(email: email, password: password) { result in
            DispatchQueue.main.async {
                self.loginButton.isEnabled = true

                switch result {
                case .success(let response):
                    SessionManager.shared.token = response.access_token
                    self.goToHome()

                case .failure:
                    self.showAlert(title: "Erreur", message: "Identifiants incorrects")
                }
            }
        }
    }

    private func goToHome() {
        let homeVC = HomeViewController()
        homeVC.modalPresentationStyle = .fullScreen
        present(homeVC, animated: true)
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func hideKeyboardOnTap() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

