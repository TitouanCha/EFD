//
//  TourDetailViewController.swift
//  DelivererApp
//
//  Created by Hugo Miesch on 18/12/2025.
//

import UIKit
import MapKit
import CoreLocation

class TourDetailViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var parcelsLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var validateButton: UIButton!

    var tour: Tour!

    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private var selectedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Détail tournée"
        displayTour()
        setupLocation()
    }

    private func displayTour() {
        dateLabel.text = "Date : \(tour.date)"
        statusLabel.text = "Statut : \(tour.status)"
        parcelsLabel.text = "Colis : \(tour.parcelCount)"
    }

    private func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
    }

    @IBAction func validateTapped(_ sender: UIButton) {
        openCamera()
    }

    private func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }

        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }

    private func sendProof() {
        guard
            let image = selectedImage,
            let location = currentLocation,
            let token = SessionManager.shared.token
        else { return }

        AuthAPI.shared.sendProof(
            token: token,
            tourId: tour.id,
            image: image,
            lat: location.coordinate.latitude,
            lng: location.coordinate.longitude
        ) {
            DispatchQueue.main.async {
                self.showSuccess()
            }
        }
    }

    private func showSuccess() {
        let alert = UIAlertController(
            title: "Succès",
            message: "Livraison validée",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        })

        present(alert, animated: true)
    }

}

extension TourDetailViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first
    }
}

extension TourDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        selectedImage = info[.originalImage] as? UIImage
        picker.dismiss(animated: true)
        sendProof()
    }
}


