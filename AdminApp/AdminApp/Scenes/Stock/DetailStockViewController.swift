//
//  DetailStockViewController.swift
//  AdminApp
//
//  Created by Titouan Chauché on 19/12/2025.
//

import UIKit

class DetailStockViewController: UIViewController {
    var parcel: Parcel!
    var tour: Tour!

    @IBOutlet weak var parcelTrackingId: UILabel!
    @IBOutlet weak var parcelStatus: UILabel!
    
    @IBOutlet weak var clientName: UILabel!
    @IBOutlet weak var clientAddress: UILabel!
    
    @IBOutlet weak var tourDate: UILabel!
    @IBOutlet weak var tourStatus: UILabel!
    
    @IBOutlet weak var deliveryManName: UILabel!
    @IBOutlet weak var deliveryManEmail: UILabel!
    
    class func newInstance(parcel: Parcel) -> DetailStockViewController {
        let detail = DetailStockViewController()
        detail.parcel = parcel
        return detail
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.parcelTrackingId.text = "#\(parcel.trackingId)"
        self.parcelStatus.text = "Status : \(parcel.status)"
        
        self.clientName.text = "Nom : \(parcel.recipientName)"
        self.clientAddress.text = "Adresse : \(parcel.address)"
        
        if let tourId = parcel.tourId {
            TourServices.getTourById(id: tourId) { tour, err in
                DispatchQueue.main.async {
                    if let error = err {
                        let alert = UIAlertController(title: "Erreur", message: "Impossible de charger colis : \(error.localizedDescription)", preferredStyle: .alert)
                        print("Impossible de charger les livreurs : \(error.localizedDescription)")
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true)
                        return
                    }
                    self.tour = tour
                    
                    self.tourDate.text = "Date : \(self.tour.date)"
                    self.tourStatus.text = "Statut : \(self.tour.status)"
                    
                    self.deliveryManName.text = "Nom : \(self.tour.courierId.name)"
                    self.deliveryManEmail.text = "Email : \(self.tour.courierId.email)"
                    
                }
                
            }
            
        }
    }

    @IBAction func tourDetailBtn(_ sender: Any) {
        let detail = DetailTourViewController.newInstance(deliveryTour: tour)
        self.navigationController?.pushViewController(detail, animated: true)

    }
    
    @IBAction func deliveryMan(_ sender: Any) {
        let deliveryMan = self.tour.courierId
        let detail = DeliveryMenDetailViewController.newInstance(deliveryMan: deliveryMan)
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    @IBAction func goBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
