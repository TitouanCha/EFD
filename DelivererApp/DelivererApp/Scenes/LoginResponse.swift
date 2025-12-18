//
//  LoginResponse.swift
//  DelivererApp
//
//  Created by Hugo Miesch on 17/12/2025.
//

struct LoginResponse: Decodable {
    let access_token: String
    let user: UserResponse
}

struct UserResponse: Decodable {
    let id: String
    let email: String
    let role: String
    let name: String
}
