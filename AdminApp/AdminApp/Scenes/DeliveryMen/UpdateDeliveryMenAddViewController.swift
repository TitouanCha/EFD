//
//  UpdateDeliveryMenAddViewController.swift
//  AdminApp
//
//  Created by Titouan Chauché on 18/12/2025.
//

import UIKit

class UpdateDeliveryMenAddViewController: UIViewController {
    var deliveryMan: User!
    
    class func newInstance(deliveryMan: User) -> UpdateDeliveryMenAddViewController {
        let detail = UpdateDeliveryMenAddViewController()
        detail.deliveryMan = deliveryMan
        return detail
    }
    
    @IBOutlet weak var updateTitle: UILabel!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var mdpI1nput: UITextField!
    @IBOutlet weak var mdp2Input: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateTitle.text = "Modifier le livreur : \(deliveryMan.name)"
        self.nameInput.placeholder = self.deliveryMan.name
        self.emailInput.placeholder = self.deliveryMan.email
        
    }
    
    @IBAction func updateBtn(_ sender: Any) {
        let deliveryManId = self.deliveryMan.id
        let name = nameInput.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailInput.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let mdp1 = mdpI1nput.text
        let mdp2 = mdp2Input.text

        var password: String? = nil
        if let mdp1 = mdp1, !mdp1.isEmpty,
           let mdp2 = mdp2, !mdp2.isEmpty {

            if mdp1.count < 6 {
                let alert = UIAlertController(
                    title: "Erreur",
                    message: "Le mot de passe doit contenir au moins 6 caractères",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
                return
            }

            if mdp1 != mdp2 {
                let alert = UIAlertController(
                    title: "Erreur",
                    message: "Les mots de passe ne sont pas identiques",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
                return
            }

            password = mdp1
        }

        let body = updateCourierBody(
            name: name?.isEmpty == true ? nil : name,
            email: email?.isEmpty == true ? nil : email,
            password: password
        )

        Delivery.updateDeliveryMan(body: body, id: deliveryManId) { error in
            DispatchQueue.main.async {
                
                if let error = error {
                    let alert = UIAlertController(
                        title: "Erreur",
                        message: "Impossible de modifier le livreur \(error)",
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
    

}
