//
//  ClientAreaViewController.swift
//  UserApp
//
//  Created by Luca Guilliere on 18/12/2025.
//

import UIKit

final class ClientAreaViewController: UIViewController {

    @IBOutlet weak var DeconexionButton: UIButton!
    @IBOutlet weak var ParcelsButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        ParcelsButton.setTitle("Mes colis", for: .normal)
        DeconexionButton.setTitle("Déconnexion", for: .normal)
    }

    @IBAction func didTapMyParcels(_ sender: Any) {
        navigationController?.pushViewController(MyParcelsViewController(), animated: true)
    }

    @IBAction func didTapLogout(_ sender: Any) {
        AuthStore.shared.logout()
        navigationController?.popToRootViewController(animated: true)
    }
}

