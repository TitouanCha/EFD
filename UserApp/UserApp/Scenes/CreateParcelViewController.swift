//
//  CreateParcelViewController.swift
//  UserApp
//
//  Created by Luca Guilliere on 19/12/2025.
//

import UIKit

final class CreateParcelViewController: UIViewController {

    @IBOutlet weak var trackingIdTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var recipientTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var CreateButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Créer un colis"
        messageLabel.text = ""
        CreateButton.setTitle("Créer", for: .normal)
    }

    @IBAction func didTapCreate(_ sender: Any) {
        let trackingId = (trackingIdTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let recipient = (recipientTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let address = (addressTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trackingId.isEmpty, !recipient.isEmpty, !address.isEmpty else {
            messageLabel.text = "Champs requis manquants"
            return
        }

        guard let weight = Double((weightTextField.text ?? "").replacingOccurrences(of: ",", with: ".")) else {
            messageLabel.text = "Poids invalide"
            return
        }

        messageLabel.text = "Création…"

        let payload = CreateParcelRequest(
            trackingId: trackingId,
            weightKg: weight,
            recipientName: recipient,
            address: address
        )

        Task {
            do {
                _ = try await APIClient.shared.createParcel(payload)
                await MainActor.run {
                    self.navigationController?.popViewController(animated: true)
                }
            } catch {
                await MainActor.run {
                    self.messageLabel.text = "Erreur de création"
                    print("createParcel error:", error)
                }
            }
        }
    }
}
