//
//  user.swift
//  AdminApp
//
//  Created by Titouan Chauché on 27/10/2025.
//

class User{
    let access_token: String
    let id: String
    let email: String
    let role: String
    let name: String
    
    init(access_token: String, id: String, email: String, role: String, name: String) {
        self.access_token = access_token
        self.id = id
        self.email = email
        self.role = role
        self.name = name
    }
}


extension User{
    convenience init?(fromLoginResponse response: [String: Any]) {
        guard let access_token = response["access_token"] as? String,
              let userDict = response["user"] as? [String: Any],
              let id = userDict["id"] as? String,
              let email = userDict["email"] as? String,
              let role = userDict["role"] as? String,
              let name = userDict["name"] as? String
        else {
            return nil
        }
        
        self.init(access_token: access_token, id: id, email: email, role: role, name: name)
    }
}
