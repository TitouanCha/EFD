//
//  DetailTourViewController.swift
//  AdminApp
//
//  Created by Titouan Chauché on 18/12/2025.
//

import UIKit

class DetailTourViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var deliveryTour: Tour!
    var deliveryParcels: [Parcel]!

    @IBOutlet weak var tourDate: UILabel!
    @IBOutlet weak var tourStatus: UILabel!
    
    @IBOutlet weak var deliveryManName: UILabel!
    @IBOutlet weak var deliveryManEmail: UILabel!
    
    @IBOutlet weak var parcelTableView: UITableView!
    
    
    class func newInstance(deliveryTour: Tour) -> DetailTourViewController {
        let detail = DetailTourViewController()
        detail.deliveryTour = deliveryTour
        return detail
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.parcelTableView.dataSource = self
        self.parcelTableView.delegate = self
        
        self.deliveryParcels = self.deliveryTour.parcelIds
        
        self.tourDate.text = "Date : \(self.deliveryTour.date)"
        self.tourStatus.text = "Status : \(self.deliveryTour.status)"
        
        self.deliveryManEmail.text = self.deliveryTour.courierId.email
        self.deliveryManName.text = self.deliveryTour.courierId.name
        
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
    
    @IBAction func userDetailBtn(_ sender: Any) {
        let userDetail = DeliveryMenDetailViewController.newInstance(deliveryMan: self.deliveryTour.courierId)
        self.navigationController?.pushViewController(userDetail, animated: true)
    }
    
    @IBAction func deleteBtn(_ sender: Any) {
        let deliveryTourId = self.deliveryTour.id
        TourServices.delDeliveryTour(id: deliveryTourId) { error in
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
    @IBAction func goBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
