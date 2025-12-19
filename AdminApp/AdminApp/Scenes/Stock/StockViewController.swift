//
//  StockViewController.swift
//  AdminApp
//
//  Created by Titouan Chauché on 19/12/2025.
//

import UIKit

class StockViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var deliveryParcels: [Parcel]!{
        didSet {
            self.parcelTableView.reloadData()
        }
    }
    
    @IBOutlet weak var parcelTableView: UITableView!
    
    func loadParcels() {
        ParcelServices.getParcels { parcels, err in
                DispatchQueue.main.async {
                    if let error = err {
                        let alert = UIAlertController(title: "Erreur", message: "Impossible de charger colis : \(error.localizedDescription)", preferredStyle: .alert)
                        print("Impossible de charger les livreurs : \(error.localizedDescription)")
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true)
                        return
                    }
                    guard let parcels = parcels else {
                        let alert = UIAlertController(title: "Erreur", message: "Aucun colis trouvé.", preferredStyle: .alert)
                        print("Aucun livreur trouvé.")
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true)
                        return
                    }
                    print(parcels.count)
                    self.deliveryParcels = parcels
                }
            }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadParcels()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.parcelTableView.dataSource = self
        self.parcelTableView.delegate = self
        loadParcels()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deliveryParcels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let parcel = deliveryParcels![indexPath.row]

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ParcelCell"
        ) ?? UITableViewCell(style: .subtitle, reuseIdentifier: "ParcelCell")

        cell.textLabel?.text = parcel.trackingId
        cell.textLabel?.font = .systemFont(ofSize: 25, weight: .medium)

        cell.detailTextLabel?.numberOfLines = 4
        cell.detailTextLabel?.text =
        """
        Poid : \(parcel.weightKg)
        Status : \(parcel.status)
        Adresse de livrason : 
        \(parcel.address)
        """
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 20)
        cell.detailTextLabel?.textColor = .darkGray

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let parcel = deliveryParcels![indexPath.row]
        let detail = DetailStockViewController.newInstance(parcel: parcel)
        self.navigationController?.pushViewController(detail, animated: true)
    
    }


    

}
