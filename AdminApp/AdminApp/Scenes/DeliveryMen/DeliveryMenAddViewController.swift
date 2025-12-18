//
//  DeliveryMenAddViewController.swift
//  AdminApp
//
//  Created by Titouan Chauché on 17/12/2025.
//

import UIKit

class DeliveryMenAddViewController: UIViewController {

    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var mdpI1nput: UITextField!
    @IBOutlet weak var mdp2Input: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func addCouriersBtn(_ sender: Any) {
        guard
            let name = nameInput?.text,
            let email = emailInput?.text,
            let mdp1 = mdpI1nput?.text,
            let mdp2 = mdp2Input?.text
        else {
            let alert = UIAlertController(
                title: "Erreur",
                message: "Informations incomplètes",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
            return
        }
        
        if(mdp1.count < 5){
            let alert = UIAlertController(
                title: "Erreur",
                message: "Le mot de passe doit contenire au moins 6 caracteres",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
            return
        }
        
        if(mdp1 != mdp2){
            let alert = UIAlertController(
                title: "Erreur",
                message: "Les mots de passe ne sont pas identiques",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
            return
        }
        
        let body = CourierBody(name: name, email: email, password: mdp1)
        Delivery.addDeliveryMan(body: body) { error in
            DispatchQueue.main.async {

                if let error = error {
                    let alert = UIAlertController(
                        title: "Erreur",
                        message: "Impossible creer le livreur \(error)",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                    return
                }

                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    @IBAction func goBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    

}
