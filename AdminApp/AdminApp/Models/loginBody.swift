//
//  loginBody.swift
//  AdminApp
//
//  Created by Titouan Chauché on 27/10/2025.
//

class LoginBody {
    let email: String
    let password: String
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    func toDictionary() -> [String: Any] {
        return ["email": self.email, "password": self.password]
    }
    
    
}
