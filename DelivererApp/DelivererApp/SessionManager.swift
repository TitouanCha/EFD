//
//  SessionManager.swift
//  DelivererApp
//
//  Created by Hugo Miesch on 17/12/2025.
//

import Foundation

final class SessionManager {

    static let shared = SessionManager()
    private init() {}

    private let tokenKey = "auth_token"

    var token: String? {
        get {
            UserDefaults.standard.string(forKey: tokenKey)
        }
        set {
            if let newValue = newValue {
                UserDefaults.standard.set(newValue, forKey: tokenKey)
            } else {
                UserDefaults.standard.removeObject(forKey: tokenKey)
            }
        }
    }
    
    var isLoggedIn: Bool {
        return token != nil
    }

    func logout() {
        token = nil
    }
}
