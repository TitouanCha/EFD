//
//  AuthAPI.swift
//  DelivererApp
//
//  Created by Hugo Miesch on 17/12/2025.
//

import UIKit

final class AuthAPI {

    static let shared = AuthAPI()
    private init() {}

    private let baseURL = "http://localhost:3001"

    // MARK: - LOGIN

    func login(
        email: String,
        password: String,
        completion: @escaping (Result<LoginResponse, Error>) -> Void
    ) {
        let url = URL(string: "\(baseURL)/auth/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["email": email, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            let decoded = try! JSONDecoder().decode(LoginResponse.self, from: data!)
            completion(.success(decoded))
        }.resume()
    }

    // MARK: - TOURS (TOKEN REQUIRED)

    func getMyTours(completion: @escaping ([Tour]) -> Void) {

        guard
            let token = SessionManager.shared.token,
            let courierId = SessionManager.shared.userId
        else {
            completion([])
            return
        }

        let url = URL(string: "\(baseURL)/tours/courier/\(courierId)")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, _ in
            let tours = (try? JSONDecoder().decode([Tour].self, from: data!)) ?? []
            completion(tours)
        }.resume()
    }

    // MARK: - PROOFS (TOKEN REQUIRED)

    func sendProof(
        parcelId: String,
        image: UIImage,
        lat: Double,
        lng: Double,
        completion: @escaping () -> Void
    ) {
        guard let token = SessionManager.shared.token else { return }

        let url = URL(string: "\(baseURL)/proofs")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()

        func add(_ s: String) { data.append(s.data(using: .utf8)!) }

        add("--\(boundary)\r\n")
        add("Content-Disposition: form-data; name=\"parcelId\"\r\n\r\n\(parcelId)\r\n")

        add("--\(boundary)\r\n")
        add("Content-Disposition: form-data; name=\"lat\"\r\n\r\n\(lat)\r\n")

        add("--\(boundary)\r\n")
        add("Content-Disposition: form-data; name=\"lng\"\r\n\r\n\(lng)\r\n")

        if let img = image.jpegData(compressionQuality: 0.7) {
            add("--\(boundary)\r\n")
            add("Content-Disposition: form-data; name=\"image\"; filename=\"proof.jpg\"\r\n")
            add("Content-Type: image/jpeg\r\n\r\n")
            data.append(img)
            add("\r\n")
        }

        add("--\(boundary)--\r\n")
        request.httpBody = data

        URLSession.shared.dataTask(with: request) { _, _, _ in
            completion()
        }.resume()
    }
}


