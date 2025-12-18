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
    private let userIdKey = "user_id"
    private let roleKey = "user_role"

    var token: String? {
        get { UserDefaults.standard.string(forKey: tokenKey) }
        set {
            if let v = newValue {
                UserDefaults.standard.set(v, forKey: tokenKey)
            } else {
                UserDefaults.standard.removeObject(forKey: tokenKey)
            }
        }
    }

    var userId: String? {
        get { UserDefaults.standard.string(forKey: userIdKey) }
        set {
            if let v = newValue {
                UserDefaults.standard.set(v, forKey: userIdKey)
            } else {
                UserDefaults.standard.removeObject(forKey: userIdKey)
            }
        }
    }

    var role: String? {
        get { UserDefaults.standard.string(forKey: roleKey) }
        set {
            if let v = newValue {
                UserDefaults.standard.set(v, forKey: roleKey)
            } else {
                UserDefaults.standard.removeObject(forKey: roleKey)
            }
        }
    }

    var isLoggedIn: Bool {
        token != nil && userId != nil
    }

    func saveSession(token: String, userId: String, role: String) {
        self.token = token
        self.userId = userId
        self.role = role
    }

    func logout() {
        token = nil
        userId = nil
        role = nil
    }
}



