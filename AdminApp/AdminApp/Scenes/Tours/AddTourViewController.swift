//
//  AddTourViewController.swift
//  AdminApp
//
//  Created by Titouan Chauché on 18/12/2025.
//

import UIKit

class AddTourViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var deliveryMen: [User]! {
        didSet {
            self.deliveryMenTableView.reloadData()
        }
    }
    var parcels: [Parcel]! {
        didSet {
            self.parcelTableView.reloadData()
        }
    }
    var selectedDeliveryMan: String!
    var selectedParcels: [String]! = []
    
    @IBOutlet weak var parcelTableView: UITableView!
    @IBOutlet weak var deliveryMenTableView: UITableView!
    
    @IBOutlet weak var dateInput: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.deliveryMenTableView.dataSource = self
        self.deliveryMenTableView.delegate = self
        
        self.parcelTableView.dataSource = self
        self.parcelTableView.delegate = self
        self.parcelTableView.allowsMultipleSelection = true

        
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
                    self.deliveryMen = deliveryMen
                }
            }
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
                    self.parcels = parcels.filter {
                        $0.status == "PENDING"
                    }
                }
            }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == deliveryMenTableView {
            return deliveryMen?.count ?? 0
        }
        if tableView == parcelTableView {
            return parcels?.count ?? 0
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if tableView == deliveryMenTableView {
            let man = deliveryMen![indexPath.row]

            let cell = tableView.dequeueReusableCell(
                withIdentifier: "DeliveryMenCell"
            ) ?? UITableViewCell(style: .subtitle, reuseIdentifier: "DeliveryMenCell")

            cell.textLabel?.text = man.name
            cell.textLabel?.font = .systemFont(ofSize: 25, weight: .bold)

            cell.detailTextLabel?.text = man.email
            cell.detailTextLabel?.font = .systemFont(ofSize: 15)
            cell.detailTextLabel?.textColor = .darkGray

            cell.accessoryType = (man.id == selectedDeliveryMan) ? .checkmark : .none

            return cell
        }

        let parcel = parcels![indexPath.row]

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ParcelCell"
        ) ?? UITableViewCell(style: .subtitle, reuseIdentifier: "ParcelCell")

        cell.textLabel?.text = parcel.trackingId
        cell.textLabel?.font = .systemFont(ofSize: 20, weight: .medium)

        cell.detailTextLabel?.text = "Statut : \(parcel.status)"
        cell.detailTextLabel?.font = .systemFont(ofSize: 15)
        cell.detailTextLabel?.textColor = .gray

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.parcelTableView {
            let parcel = parcels[indexPath.row]
            self.selectedParcels.append(parcel.id)
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.accessoryType = .checkmark
            }
        }
        
        if(tableView == self.deliveryMenTableView){
            let man = deliveryMen[indexPath.row]
            self.selectedDeliveryMan = man.id
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView == parcelTableView {
            let parcel = parcels[indexPath.row]
            self.selectedParcels.removeAll { $0 == parcel.id }

            if let cell = tableView.cellForRow(at: indexPath) {
                cell.accessoryType = .none
            }
        }
    }
    
    
    @IBAction func addBtn(_ sender: Any) {
        let selectedDate = self.dateInput.date
        let today = Date()
        if selectedDate < today {
            let alert = UIAlertController(
                title: "Erreur",
                message: "La date sélectionnée ne peut pas être dans le passé.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
            return
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let dateString = formatter.string(from: selectedDate)
        
        guard let selectedDeliveryManId = self.selectedDeliveryMan,
              let selectedParcelsIds = self.selectedParcels
        else {
            return
        }
        
        let body = tourBody(date: dateString, parcelIds: selectedParcelsIds, courierId: selectedDeliveryManId)
        
        TourServices.addTour(body: body) { error in
            DispatchQueue.main.async {

                if let error = error {
                    let alert = UIAlertController(
                        title: "Erreur",
                        message: "Impossible creer la tournée \(error)",
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
