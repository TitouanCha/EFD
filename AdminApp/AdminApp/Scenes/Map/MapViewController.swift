//
//  MapViewController.swift
//  AdminApp
//
//  Created by Titouan Chauché on 21/10/2025.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    var parcels: [Parcel]!
    
    
    @IBOutlet weak var DeliveryMap: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.DeliveryMap.delegate = self
        
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
                    self.parcels = parcels
                    
                    let points: [MKAnnotation] = parcels.map {
                        ParcelAnnotation(parcel: $0)
                    }
                    self.DeliveryMap.removeAnnotations(self.DeliveryMap.annotations)
                    self.DeliveryMap.addAnnotations(points)

                }
            }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let a = annotation as? ParcelAnnotation else { return nil }

        var view = mapView.dequeueReusableAnnotationView(withIdentifier: "parcel") as? MKMarkerAnnotationView
        if view == nil {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "parcel")
            view!.canShowCallout = true
        } else {
            view!.annotation = annotation
        }
        
        print(a.parcel.status)
        switch a.parcel.status {
        case "OUT_FOR_DELIVERY":
            view!.markerTintColor = .systemBlue
        case "DELIVERED":
            view!.markerTintColor = .systemGreen
        default:
            view!.markerTintColor = .systemOrange
        }

        return view
    }

    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? ParcelAnnotation else { return }

        let parcel = annotation.parcel
        let detail = DetailStockViewController.newInstance(parcel: parcel)
        self.navigationController?.pushViewController(detail, animated: true)
        
    }

    

    @IBAction func goBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
