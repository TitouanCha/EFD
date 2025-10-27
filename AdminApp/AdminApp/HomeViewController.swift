//
//  HomeViewController.swift
//  AdminApp
//
//  Created by Titouan Chauché on 06/10/2025.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var input_login: UITextField!
    @IBOutlet weak var input_password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func connection(_ sender: UIButton) {
        guard let login = input_login.text, let password = input_password.text else {
            return
        }
        Auth.login(email: login, password: password){
            user, err in
            DispatchQueue.main.async {
                guard let user = user else {
                    print("Erreur de connexion")
                    return
                }
                let role = user.role
                UserDefaults.standard.set(user.access_token, forKey: "API_TOKEN")
                
                if(role == "ADMIN"){
                    UIView.transition(with: self.navigationController!.view, duration: 0.3, options: .transitionCrossDissolve) {
                        self.navigationController?.viewControllers = [DashBoardViewController(nibName: "DashBoardViewController", bundle: nil)]
                    }
                }
            }
        }
        
    }
    
    
}
