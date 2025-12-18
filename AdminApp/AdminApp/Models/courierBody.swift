//
//  courierBody.swift
//  AdminApp
//
//  Created by Titouan Chauché on 18/12/2025.
//

class CourierBody {
    let name: String
    let email: String
    let password: String
    let role: String = "COURIER"
    
    init(name: String, email: String, password: String) {
        self.name = name
        self.email = email
        self.password = password
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "name": self.name,
            "email": self.email,
            "password": self.password,
            "role": self.role
        ]
    }
}

class updateCourierBody {
    let name: String?
    let email: String?
    let password: String?
    
    init(name: String? = nil, email: String? = nil, password: String? = nil) {
        self.name = name
        self.email = email
        self.password = password
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        
        if let name = self.name {
            dictionary["name"] = name
        }
        if let email = self.email {
            dictionary["email"] = email
        }
        if let password = self.password {
            dictionary["password"] = password
        }
        return dictionary
    }
}
