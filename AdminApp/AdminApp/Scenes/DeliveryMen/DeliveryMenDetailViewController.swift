//
//  DeliveryMenDetailViewController.swift
//  AdminApp
//
//  Created by Titouan Chauché on 17/12/2025.
//

import UIKit

class DeliveryMenDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var deliveryMan: User!
    var deliveryManTour: [Tour]! {
        didSet {
            self.tourTableView.reloadData()
        }
    }
    
    @IBOutlet weak var deliveryManName: UILabel!
    @IBOutlet weak var deliveryManEmail: UILabel!
    
    @IBOutlet weak var tourTableView: UITableView!
    
    class func newInstance(deliveryMan: User) -> DeliveryMenDetailViewController {
        let detail = DeliveryMenDetailViewController()
        detail.deliveryMan = deliveryMan
        return detail
    }
    
    func loadDeliveryTour(){
        TourServices.getTour{ deliveryManTour, err in
                DispatchQueue.main.async {
                    if let error = err {
                        let alert = UIAlertController(title: "Erreur", message: "Impossible de charger les livraisons : \(error.localizedDescription)", preferredStyle: .alert)
                        print("Impossible de charger les livreurs : \(error.localizedDescription)")
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true)
                        return
                    }
                    guard let deliveryManTour = deliveryManTour else {
                        let alert = UIAlertController(title: "Erreur", message: "Aucune livraison trouvé.", preferredStyle: .alert)
                        print("Aucun livreur trouvé.")
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true)
                        return
                    }
                    print(deliveryManTour.count)
                    self.deliveryManTour = deliveryManTour.filter {
                        $0.courierId == self.deliveryMan.id
                    }.sorted {
                        $0.date < $1.date
                    }
                        
                }
            }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDeliveryTour()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        deliveryManName.text = deliveryMan.name
        deliveryManEmail.text = deliveryMan.email
        
        self.tourTableView.dataSource = self
        self.tourTableView.delegate = self
        loadDeliveryTour()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.deliveryManTour?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tour = self.deliveryManTour![indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "TourCell")
        if(cell == nil){
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "TourCell")
        }
        cell!.textLabel?.text = tour.date
        cell!.textLabel?.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        
        cell!.detailTextLabel?.numberOfLines = 2
        cell!.detailTextLabel?.text =
        """
        Nombre de colis : \(tour.parcelIds.count)
        Statut : \(tour.status)
        """
        cell!.detailTextLabel?.font = UIFont.systemFont(ofSize: 25)
        cell!.detailTextLabel?.textColor = .darkGray


        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    @IBAction func suppButton(_ sender: Any) {
        let deliveryManId = self.deliveryMan.id
        Delivery.delDeliveryMan(id: deliveryManId) { error in
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
    @IBAction func updateButton(_ sender: Any) {
        let man = self.deliveryMan!
        let detail = UpdateDeliveryMenAddViewController.newInstance(deliveryMan: man)
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    
    @IBAction func goBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
