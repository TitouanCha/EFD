//
//  DashBoardViewController.swift
//  AdminApp
//
//  Created by Titouan Chauché on 21/10/2025.
//

import UIKit

class DashBoardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func stockButton(_ sender: Any) {
        let stockViewController = StockViewController()
        navigationController!.pushViewController(stockViewController, animated: true)
    }
    
    @IBAction func mapButton(_ sender: UIButton) {
        let mapViewController = MapViewController()
        navigationController!.pushViewController(mapViewController, animated: true)
    }
    
    @IBAction func toursButton(_ sender: Any) {
        let toursViewController = ToursViewController()
        navigationController!.pushViewController(toursViewController, animated: true)
    }
    
    @IBAction func deliveryMenButton(_ sender: Any) {
        let deliveryMenViewController = DeliveryMenViewController()
        navigationController!.pushViewController(deliveryMenViewController, animated: true)
    }
    
    @IBAction func deliveryButton(_ sender: Any) {
        let deliveryViewController = DeliveryViewController()
        navigationController!.pushViewController(deliveryViewController, animated: true)
    }
    
    
}
