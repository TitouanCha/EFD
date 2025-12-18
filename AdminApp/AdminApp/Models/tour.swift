//
//  tour.swift
//  AdminApp
//
//  Created by Titouan Chauché on 17/12/2025.
//

class Tour {
    let id: String
    let date: String
    let courierId: User
    let parcelIds: [Parcel]
    let status: String

    init(id: String, date: String, courierId: User, parcelIds: [Parcel], status: String) {
        self.id = id
        self.date = date
        self.courierId = courierId
        self.parcelIds = parcelIds
        self.status = status
    }
}

extension Tour {

    convenience init?(fromAPI dict: [String: Any]) {

        guard let id = dict["_id"] as? String,
              let date = dict["date"] as? String,
              let courierDict = dict["courierId"] as? [String: Any],
              let courier = User(fromAPI: courierDict),
              let parcelDicts = dict["parcelIds"] as? [[String: Any]],
              let status = dict["status"] as? String
        else {
            return nil
        }

        let parcels = parcelDicts.compactMap(Parcel.init(fromAPI:))

        self.init(
            id: id,
            date: date,
            courierId: courier,
            parcelIds: parcels,
            status: status
        )
    }
}

