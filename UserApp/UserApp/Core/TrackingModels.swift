//
//  TrackingModels.swift
//  UserApp
//
//  Created by Luca Guilliere on 18/12/2025.
//

import Foundation

struct TrackingResponse: Decodable {
    let trackingId: String
    let status: String
    let courierEstimate: String?
}
