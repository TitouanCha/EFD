//
//  ToursViewController.swift
//  AdminApp
//
//  Created by Titouan Chauché on 21/10/2025.
//

import UIKit

class ToursViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var deliveryTour: [Tour]! {
        didSet {
            self.tourTableView.reloadData()
        }
    }
    
    @IBOutlet weak var tourTableView: UITableView!
    
    func loadDeliveryTour(){
        TourServices.getTour{ deliveryTour, err in
                DispatchQueue.main.async {
                    if let error = err {
                        let alert = UIAlertController(title: "Erreur", message: "Impossible de charger les livraisons : \(error.localizedDescription)", preferredStyle: .alert)
                        print("Impossible de charger les livreurs : \(error.localizedDescription)")
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true)
                        return
                    }
                    guard let deliveryTour = deliveryTour else {
                        let alert = UIAlertController(title: "Erreur", message: "Aucune livraison trouvé.", preferredStyle: .alert)
                        print("Aucun livreur trouvé.")
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true)
                        return
                    }
                    print(deliveryTour.count)
                    self.deliveryTour = deliveryTour.sorted {
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
        self.tourTableView.dataSource = self
        self.tourTableView.delegate = self
        loadDeliveryTour()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.deliveryTour?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tour = self.deliveryTour![indexPath.row]
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

    @IBAction func addTourbtn(_ sender: Any) {
        let add = AddTourViewController()
        self.navigationController?.pushViewController(add, animated: true)
    }
    
    @IBAction func goBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

