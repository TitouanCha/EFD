//
//  TrackingViewController.swift
//  UserApp
//
//  Created by Luca Guilliere on 18/12/2025.
//

import UIKit

final class TrackingViewController: UIViewController {

    @IBOutlet weak var trackingTextField: UITextField!
    @IBOutlet weak var trackingLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var estimateLabel: UILabel!
    @IBOutlet weak var SearchButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialState()
        SearchButton.setTitle("Chercher", for: .normal)
    }

    private func setInitialState() {
            trackingLabel.text = "Tracking ID : —"
            statusLabel.text = "Statut : —"
            estimateLabel.text = "Estimation : —"
            errorLabel.isHidden = true
        }

        private func setLoadingState() {
            trackingLabel.text = "Tracking ID : …"
            statusLabel.text = "Statut : Chargement…"
            estimateLabel.text = "Estimation : …"
            errorLabel.isHidden = true
        }

        private func setResultState(_ res: TrackingResponse) {
            trackingLabel.text = "Tracking ID : \(res.trackingId)"
            statusLabel.text = "Statut : \(formatStatus(res.status))"
            estimateLabel.text = "Estimation : \(res.courierEstimate ?? "Non disponible")"
            errorLabel.isHidden = true
        }

        private func setErrorState(_ msg: String) {
            setInitialState()
            errorLabel.text = msg
            errorLabel.isHidden = false
        }

        @IBAction func didTapSearch(_ sender: Any) {
            let id = (trackingTextField.text ?? "")
                .trimmingCharacters(in: .whitespacesAndNewlines)

            guard !id.isEmpty else {
                setErrorState("Tracking ID requis")
                return
            }

            setLoadingState()

            Task {
                do {
                    let res = try await APIClient.shared.getTracking(trackingId: id)
                    await MainActor.run {
                        self.setResultState(res)
                    }
                } catch {
                    await MainActor.run {
                        self.setErrorState("Colis introuvable")
                    }
                }
            }
        }

        private func formatStatus(_ status: String) -> String {
            switch status {
            case "PENDING": return "En attente"
            case "IN_TRANSIT": return "En cours de livraison"
            case "DELIVERED": return "Livré"
            default: return status
            }
        }
    }
