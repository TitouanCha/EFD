//
//  delivery.swift
//  AdminApp
//
//  Created by Titouan Chauché on 16/12/2025.
//
import Foundation

class Delivery {
    class func getDeliveryMen(completion: @escaping ([User]?, Error?) -> Void) {
        let url = URL(string: "http://localhost:3001/users?role=COURIER")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        guard let token = UserDefaults.standard.string(forKey: "API_TOKEN") else {
            completion(nil, NSError(domain: "com.tc.no_token", code: 401))
            return
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, res, err in
            guard err == nil else {
                completion(nil, err)
                return
            }
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data),
                  let jsonArr = json as? [[String: Any]]
            else {
                completion(nil, NSError(domain: "com.tc.invalid_json", code: 1))
                return
            }
            let users = jsonArr.compactMap(User.init(fromAPI:))
            completion(users, nil)
        }
        dataTask.resume()
    }

    
    
}
