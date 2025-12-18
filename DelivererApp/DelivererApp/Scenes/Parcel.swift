//
//  Parcels.swift
//  DelivererApp
//
//  Created by Hugo Miesch on 18/12/2025.
//

struct Parcel: Codable {
    let id: String
    let trackingId: String
    let recipientName: String
    let address: String
    let destination: Destination
    let status: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case trackingId
        case recipientName
        case address
        case destination
        case status
    }
}
