//
//  tourServices.swift
//  AdminApp
//
//  Created by Titouan Chauché on 17/12/2025.
//

import Foundation

class TourServices {
    
    class func getTour(completion: @escaping ([Tour]?, Error?) -> Void) {
        let url = URL(string: "http://localhost:3001/tours")!
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
            let tours: [Tour] = jsonArr.compactMap(Tour.init(fromAPI:))
            completion(tours, nil)
        }
        dataTask.resume()
    }
    
    class func getTourById(id: String, completion: @escaping (Tour?, Error?) -> Void) {
        let url = URL(string: "http://localhost:3001/tours/\(id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        guard let token = UserDefaults.standard.string(forKey: "API_TOKEN") else {
            completion(nil, NSError(domain: "com.tc.no_token", code: 401))
            return
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, res, err in
            if let err = err {
                completion(nil, err)
                return
            }
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data),
                  let jsonDict = json as? [String: Any]
            else {
                completion(nil, NSError(domain: "com.tc.invalid_json", code: 1))
                return
            }
        
            let tour = Tour(fromAPI: jsonDict)
            completion(tour, nil)
        }
        
        dataTask.resume()
    }

    
    class func addTour(body: tourBody, completion: @escaping (Error?) -> Void) {
        let url = URL(string: "http://localhost:3001/tours")!
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
    
    class func delDeliveryTour(id: String, completion: @escaping (Error?) -> Void) {
        let url = URL(string: "http://localhost:3001/tours/\(id)")!
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
}
