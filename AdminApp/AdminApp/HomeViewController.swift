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
    var role: String = "admin"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func connection(_ sender: UIButton) {
        guard let login = input_login.text, let password = input_password.text else {
            return
        }
        if(role == "admin"){
            UIView.transition(with: self.navigationController!.view, duration: 0.3, options: .transitionCrossDissolve) {
                self.navigationController?.viewControllers = [DashBoardViewController(nibName: "DashBoardViewController", bundle: nil)]
            }
        }
        
    }
    
    
}
