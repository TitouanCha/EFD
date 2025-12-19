//
//  LoginViewController.swift
//  UserApp
//
//  Created by Luca Guilliere on 18/12/2025.
//

import UIKit

final class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var ConnexionButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.text = ""
        ConnexionButton.setTitle("Connexion", for: .normal)
    }

    @IBAction func didTapLogin(_ sender: Any) {
        let email = (emailTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let password = (passwordTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        guard !email.isEmpty, !password.isEmpty else {
            messageLabel.text = "Email et mot de passe requis"
            return
        }

        messageLabel.text = "Connexion…"

        Task {
            do {
                let token = try await APIClient.shared.login(email: email, password: password)
                AuthStore.shared.token = token

                await MainActor.run {
                    messageLabel.text = "Connecté"
                    self.navigationController?.popViewController(animated: true)
                }
            } catch {
                await MainActor.run {
                    messageLabel.text = "Erreur de connexion"
                }
            }
        }
    }
}
