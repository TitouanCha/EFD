//
//  DeliveryMenDetailViewController.swift
//  AdminApp
//
//  Created by Titouan Chauché on 17/12/2025.
//

import UIKit

class DeliveryMenDetailViewController: UIViewController {
    var deliveryMan: User!
    
    @IBOutlet weak var deliveryManName: UILabel!
    @IBOutlet weak var deliveryManEmail: UILabel!
    
    class func newInstance(deliveryMan: User) -> DeliveryMenDetailViewController {
        let detail = DeliveryMenDetailViewController()
        detail.deliveryMan = deliveryMan
        return detail
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deliveryManName.text = deliveryMan.name
        deliveryManEmail.text = deliveryMan.email
    }

    @IBAction func suppButton(_ sender: Any) {
    }
    @IBAction func updateButton(_ sender: Any) {
    }
}
