//
//  auth.swift
//  AdminApp
//
//  Created by Titouan Chauché on 27/10/2025.
//
import Foundation

class Auth {
    
    class func login(email: String, password: String, completion: @escaping (User?, Error?) -> Void){
        let body = LoginBody(email: email, password: password)
        
        let url = URL(string: "http://localhost:3001/auth/login")!
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        let bodyDict = body.toDictionary()
        let json = try? JSONSerialization.data(withJSONObject: bodyDict) // convertir le dictionnaire en JSON
        req.httpBody = json
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let dataTask = URLSession.shared.dataTask(with: req) { data, response, err in
            guard err == nil else {
                completion(nil, err)
                return
            }
            guard let json = try? JSONSerialization.jsonObject(with: data!),
                  let jsonDict = json as? [String: Any]
            else{
                completion(nil, NSError(domain: "com.tc.invalide_json", code: 1))
                return
            }
            let user = User(fromLoginResponse: jsonDict)
            completion(user, nil)
        }
        dataTask.resume()
    }
    
    
}
