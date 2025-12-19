//
//  ParcelsMdels.swift
//  UserApp
//
//  Created by Luca Guilliere on 19/12/2025.
//

import Foundation

struct Parcel: Decodable {
    let _id: String?
    let trackingId: String
    let weightKg: Double
    let recipientName: String
    let address: String
    let status: String?
}

struct CreateParcelRequest: Encodable {
    let trackingId: String
    let weightKg: Double
    let recipientName: String
    let address: String
}
