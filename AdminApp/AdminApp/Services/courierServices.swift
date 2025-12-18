//
//  courierServices.swift
//  AdminApp
//
//  Created by Titouan Chauché on 18/12/2025.
//

import Foundation

class Delivery {
    class func addDeliveryMan(body: CourierBody, completion: @escaping (Error?) -> Void) {
        let url = URL(string: "http://localhost:3001/users")!
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        guard let token = UserDefaults.standard.string(forKey: "API_TOKEN") else {
            completion(NSError(domain: "com.tc.no_token", code: 401))
            return
        }
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let bodyDict = body.toDictionary()
        guard let json = try? JSONSerialization.data(withJSONObject: bodyDict) else {
            completion(NSError(domain: "com.tc.invalid_body", code: 400))
            return
        }
        req.httpBody = json
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let dataTask = URLSession.shared.dataTask(with: req) { data, response, err in
            if let err = err {
                completion(err)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
                completion(NSError(domain: "com.tc.http_error", code: 500))
                return
            }
            completion(nil)
        }

        dataTask.resume()
    }
    
    class func updateDeliveryMan(body: updateCourierBody, id: String, completion: @escaping (Error?) -> Void) {
        let url = URL(string: "http://localhost:3001/users/\(id)")!
        var req = URLRequest(url: url)
        req.httpMethod = "PATCH"
        guard let token = UserDefaults.standard.string(forKey: "API_TOKEN") else {
            completion(NSError(domain: "com.tc.no_token", code: 401))
            return
        }
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let bodyDict = body.toDictionary()
        guard let json = try? JSONSerialization.data(withJSONObject: bodyDict) else {
            completion(NSError(domain: "com.tc.invalid_body", code: 400))
            return
        }
        req.httpBody = json
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let dataTask = URLSession.shared.dataTask(with: req) { data, response, err in
            if let err = err {
                completion(err)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
                completion(NSError(domain: "com.tc.http_error", code: 500))
                return
            }
            completion(nil)
        }

        dataTask.resume()
    }
    
    class func delDeliveryMan(id: String, completion: @escaping (Error?) -> Void) {
        let url = URL(string: "http://localhost:3001/users/\(id)")!
        var req = URLRequest(url: url)
        req.httpMethod = "DELETE"
        guard let token = UserDefaults.standard.string(forKey: "API_TOKEN") else {
            completion(NSError(domain: "com.tc.no_token", code: 401))
            return
        }
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let dataTask = URLSession.shared.dataTask(with: req) { data, response, err in
            if let err = err {
                completion(err)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
                completion(NSError(domain: "com.tc.http_error", code: 500))
                return
            }
            completion(nil)
        }

        dataTask.resume()
    }
    
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
