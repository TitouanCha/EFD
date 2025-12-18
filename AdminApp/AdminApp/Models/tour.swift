//
//  tour.swift
//  AdminApp
//
//  Created by Titouan Chauché on 17/12/2025.
//

class Tour{
    let id: String
    let date: String
    let courierId: String
    let parcelIds: [String]
    let status: String
    
    init(id: String, date: String, courierId: String, parcelIds: [String], status: String) {
        self.id = id
        self.date = date
        self.courierId = courierId
        self.parcelIds = parcelIds
        self.status = status
    }
}

extension Tour: Identifiable {
    
    convenience init?(fromAPI dict: [String: Any]) {
        guard let id = dict["_id"] as? String,
              let date = dict["date"] as? String,
              let courierId = dict["courierId"] as? String,
              let parcelIds = dict["parcelIds"] as? [String],
              let status = dict["status"] as? String
        else { return nil }
        
        self.init(id: id, date: date, courierId: courierId, parcelIds: parcelIds, status: status)
                
    }
}
