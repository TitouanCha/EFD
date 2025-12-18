//
//  DeliveryMenViewController.swift
//  AdminApp
//
//  Created by Titouan Chauché on 21/10/2025.
//

import UIKit

class DeliveryMenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var deliveryMen: [User]! {
        didSet {
            self.deliveryMenTableView.reloadData()
        }
    }
    @IBOutlet weak var deliveryMenTableView: UITableView!
    
    
    func loadDeliveryMen(){
        Delivery.getDeliveryMen { deliveryMen, err in
                DispatchQueue.main.async {
                    if let error = err {
                        let alert = UIAlertController(title: "Erreur", message: "Impossible de charger les livreurs : \(error.localizedDescription)", preferredStyle: .alert)
                        print("Impossible de charger les livreurs : \(error.localizedDescription)")
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true)
                        return
                    }
                    guard let deliveryMen = deliveryMen else {
                        let alert = UIAlertController(title: "Erreur", message: "Aucun livreur trouvé.", preferredStyle: .alert)
                        print("Aucun livreur trouvé.")
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true)
                        return
                    }
                    print(deliveryMen.count)
                    self.deliveryMen = deliveryMen
                }
            }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDeliveryMen()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.deliveryMenTableView.dataSource = self
        self.deliveryMenTableView.delegate = self
        loadDeliveryMen()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.deliveryMen?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let man = self.deliveryMen![indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryMenCell")
        if(cell == nil){
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "DeliveryMenCell")
        }
        cell!.textLabel?.text = man.name
        cell!.textLabel?.font = UIFont.systemFont(ofSize: 30, weight: .bold) // taille + gras

        cell!.detailTextLabel?.text = man.email
        cell!.detailTextLabel?.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        cell!.detailTextLabel?.textColor = .darkGray

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let man = self.deliveryMen![indexPath.row]
        let detail = DeliveryMenDetailViewController.newInstance(deliveryMan: man)
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    @IBAction func ButtonAddDeliveryMen(_ sender: Any) {
        let add = DeliveryMenAddViewController()
        self.navigationController?.pushViewController(add, animated: true)
    }
    
    @IBAction func goBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
