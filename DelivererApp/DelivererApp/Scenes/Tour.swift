//
//  Tour.swift
//  DelivererApp
//
//  Created by Hugo Miesch on 18/12/2025.
//

struct Tour: Codable {
    let id: String
    let date: String
    let status: String
    let parcelIds: [Parcel]

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case date
        case status
        case parcelIds
    }
}


