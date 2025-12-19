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
    private var currentParcelIndex = 0

    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?

    private var selectedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Détail tournée"
        setupButton()
        setupLocation()
        updateUI()
        showCurrentParcelOnMap()
    }
    private func setupButton() {
        validateButton.setTitle("Valider la livraison", for: .normal)
        validateButton.layer.cornerRadius = 10
        validateButton.backgroundColor = .systemBlue
        validateButton.setTitleColor(.white, for: .normal)
    }

    private func updateUI() {
        dateLabel.text = "Date : \(tour.date)"
        statusLabel.text = "Statut : \(tour.status)"
        parcelsLabel.text = "Colis : \(currentParcelIndex + 1)/\(tour.parcelIds.count)"
    }

    private func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
    }

    private func showCurrentParcelOnMap() {
        mapView.removeAnnotations(mapView.annotations)

        guard currentParcelIndex < tour.parcelIds.count else { return }
        let parcel = tour.parcelIds[currentParcelIndex]

        let lng = parcel.destination.coordinates[0]
        let lat = parcel.destination.coordinates[1]

        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = parcel.recipientName
        annotation.subtitle = parcel.address

        mapView.addAnnotation(annotation)

        let region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: 800,
            longitudinalMeters: 800
        )

        mapView.setRegion(region, animated: true)
    }

    @IBAction func validateTapped(_ sender: UIButton) {
        openCamera()
    }

    private func openCamera() {
        let picker = UIImagePickerController()
        picker.delegate = self

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            // Simulateur → galerie
            picker.sourceType = .photoLibrary
        }

        present(picker, animated: true)
    }

    private func sendProof() {
        guard
            let image = selectedImage,
            let location = currentLocation,
            let token = SessionManager.shared.token,
            let courierId = SessionManager.shared.userId,
            currentParcelIndex < tour.parcelIds.count
        else { return }

        let parcel = tour.parcelIds[currentParcelIndex]

        AuthAPI.shared.sendProof(
            token: token,
            courierId: courierId,
            parcelId: parcel.id,
            image: image,
            lat: location.coordinate.latitude,
            lng: location.coordinate.longitude
        ) {
            DispatchQueue.main.async {
                self.handleNextParcel()
            }
        }
    }

    private func handleNextParcel() {
        selectedImage = nil
        currentParcelIndex += 1

        if currentParcelIndex < tour.parcelIds.count {
            updateUI()
            showCurrentParcelOnMap()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
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

