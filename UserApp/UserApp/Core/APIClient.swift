//
//  APIClient.swift
//  UserApp
//
//  Created by Luca Guilliere on 18/12/2025.
//

import Foundation

enum APIError: Error {
    case invalidResponse
    case http(Int, String)
}

final class APIClient {
    static let shared = APIClient()
    private init() {}

    private let baseURL = URL(string: "http://localhost:3001")!
    
    private struct LoginRequest: Encodable {
        let email: String
        let password: String
    }

    func login(email: String, password: String) async throws -> String {
        let url = baseURL.appendingPathComponent("auth/login")
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("application/json", forHTTPHeaderField: "Accept")

        req.httpBody = try JSONEncoder().encode(LoginRequest(email: email, password: password))

        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse else { throw APIError.invalidResponse }

        let bodyString = String(data: data, encoding: .utf8) ?? ""
        guard (200...299).contains(http.statusCode) else {
            throw APIError.http(http.statusCode, bodyString)
        }

        // token peut être dans "access_token" ou "token"
        if let obj = try JSONSerialization.jsonObject(with: data) as? [String: Any],
           let token = (obj["access_token"] as? String) ?? (obj["token"] as? String) {
            return token
        }

        throw APIError.http(http.statusCode, "No token in response: \(bodyString)")
    }
    
    func getTracking(trackingId: String) async throws -> TrackingResponse {
        let url = baseURL.appendingPathComponent("tracking/\(trackingId)")
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        let bodyString = String(data: data, encoding: .utf8) ?? ""
        guard (200...299).contains(http.statusCode) else {
            throw APIError.http(http.statusCode, bodyString)
        }

        return try JSONDecoder().decode(TrackingResponse.self, from: data)
    }
    
    private func authorizedRequest(url: URL, method: String) throws -> URLRequest {
        guard let token = AuthStore.shared.token else {
            throw APIError.http(401, "Missing token")
        }
        var req = URLRequest(url: url)
        req.httpMethod = method
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return req
    }

    func getMyParcels() async throws -> [Parcel] {
        let url = baseURL.appendingPathComponent("parcels/me")
        var req = try authorizedRequest(url: url, method: "GET")

        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse else { throw APIError.invalidResponse }

        let bodyString = String(data: data, encoding: .utf8) ?? ""
        guard (200...299).contains(http.statusCode) else {
            throw APIError.http(http.statusCode, bodyString)
        }

        return try JSONDecoder().decode([Parcel].self, from: data)
    }

    func createParcel(_ payload: CreateParcelRequest) async throws -> Parcel {
        let url = baseURL.appendingPathComponent("parcels")
        var req = try authorizedRequest(url: url, method: "POST")
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try JSONEncoder().encode(payload)

        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse else { throw APIError.invalidResponse }

        let bodyString = String(data: data, encoding: .utf8) ?? ""
        guard (200...299).contains(http.statusCode) else {
            throw APIError.http(http.statusCode, bodyString)
        }

        return try JSONDecoder().decode(Parcel.self, from: data)
    }

}
