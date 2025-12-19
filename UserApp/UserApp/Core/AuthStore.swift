//
//  AuthStore.swift
//  UserApp
//
//  Created by Luca Guilliere on 18/12/2025.
//

import Foundation

final class AuthStore {
    static let shared = AuthStore()
    private init() {}

    private let key = "auth_token"

    var token: String? {
        get { UserDefaults.standard.string(forKey: key) }
        set { UserDefaults.standard.setValue(newValue, forKey: key) }
    }

    func logout() { token = nil }
}
