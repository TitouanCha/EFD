//
//  tourBody.swift
//  AdminApp
//
//  Created by Titouan Chauché on 18/12/2025.
//

class tourBody {
    let date: String
    let parcelIds: [String]
    let courierId: String
    
    init(date: String, parcelIds: [String], courierId: String) {
        self.date = date
        self.parcelIds = parcelIds
        self.courierId = courierId
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "date": date,
            "parcelIds": parcelIds,
            "courierId": courierId
        ]
    }
}
