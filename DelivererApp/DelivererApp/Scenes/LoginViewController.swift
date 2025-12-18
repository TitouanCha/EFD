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
            showAlert("Erreur", "Veuillez remplir tous les champs")
            return
        }

        loginButton.isEnabled = false

        AuthAPI.shared.login(email: email, password: password) { result in
            DispatchQueue.main.async {
                self.loginButton.isEnabled = true

                switch result {
                case .success(let res):

                    SessionManager.shared.saveSession(
                        token: res.access_token,
                        userId: res.user.id,
                        role: res.user.role
                    )

                    self.goToHome()

                case .failure:
                    self.showAlert("Erreur", "Identifiants incorrects")
                }
            }
        }
    }

    private func goToHome() {
        let vc = HomeViewController(
            nibName: "HomeViewController",
            bundle: nil
        )
        navigationController?.setViewControllers([vc], animated: true)
    }

    private func showAlert(_ title: String, _ msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func hideKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

