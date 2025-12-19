//
//  parcel.swift
//  AdminApp
//
//  Created by Titouan Chauché on 17/12/2025.
//

import CoreLocation
import MapKit

class Parcel {
    
    let id: String
    let trackingId: String
    let weightKg: Double
    let recipientName: String
    let address: String
    let destination: CLLocationCoordinate2D
    let status: String
    let tourId: String?

    init(
        trackingId: String,
        weightKg: Double,
        recipientName: String,
        address: String,
        destination: CLLocationCoordinate2D,
        status: String,
        id: String,
        tourId: String? = nil
    ) {
        self.trackingId = trackingId
        self.weightKg = weightKg
        self.recipientName = recipientName
        self.address = address
        self.destination = destination
        self.status = status
        self.id = id
        self.tourId = tourId
    }
}

extension Parcel {

    convenience init?(fromAPI dict: [String: Any]) {
        guard
            let trackingId = dict["trackingId"] as? String,
            let weightKg = dict["weightKg"] as? Double,
            let recipientName = dict["recipientName"] as? String,
            let address = dict["address"] as? String,
            let status = dict["status"] as? String,
            let id = dict["_id"] as? String,
            let destinationDict = dict["destination"] as? [String: Any],
            let coordinates = destinationDict["coordinates"] as? [Double],
            coordinates.count == 2
        else {
            return nil
        }
        
        let destination = CLLocationCoordinate2D(
            latitude: coordinates[1],
            longitude: coordinates[0]
        )
        
        let tourId = dict["tourId"] as? String  // récupère tourId si présent

        self.init(
            trackingId: trackingId,
            weightKg: weightKg,
            recipientName: recipientName,
            address: address,
            destination: destination,
            status: status,
            id: id,
            tourId: tourId
        )
    }
}


class ParcelAnnotation: NSObject, MKAnnotation {
    let parcel: Parcel
    var coordinate: CLLocationCoordinate2D {
        parcel.destination
    }
    var title: String? {
        "Colis \(parcel.trackingId)"
    }
    var subtitle: String? {
        parcel.status
    }
    init(parcel: Parcel) {
        self.parcel = parcel
    }
}



