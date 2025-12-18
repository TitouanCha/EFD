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
        token: String,
        courierId: String,
        parcelId: String,
        image: UIImage,
        lat: Double,
        lng: Double,
        completion: @escaping () -> Void
    ) {
        guard let url = URL(string: "\(baseURL)/proofs") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let boundary = UUID().uuidString
        request.setValue(
            "multipart/form-data; boundary=\(boundary)",
            forHTTPHeaderField: "Content-Type"
        )

        let body = createMultipartBody(
            boundary: boundary,
            courierId: courierId,
            parcelId: parcelId,
            image: image,
            lat: lat,
            lng: lng
        )

        request.httpBody = body

        URLSession.shared.dataTask(with: request) { _, _, _ in
            completion()
        }.resume()
    }
    private func createMultipartBody(
        boundary: String,
        courierId: String,
        parcelId: String,
        image: UIImage,
        lat: Double,
        lng: Double
    ) -> Data {

        var data = Data()

        func append(_ string: String) {
            data.append(string.data(using: .utf8)!)
        }

        append("--\(boundary)\r\n")
        append("Content-Disposition: form-data; name=\"courierId\"\r\n\r\n")
        append("\(courierId)\r\n")

        append("--\(boundary)\r\n")
        append("Content-Disposition: form-data; name=\"parcelId\"\r\n\r\n")
        append("\(parcelId)\r\n")

        append("--\(boundary)\r\n")
        append("Content-Disposition: form-data; name=\"lat\"\r\n\r\n")
        append("\(lat)\r\n")

        append("--\(boundary)\r\n")
        append("Content-Disposition: form-data; name=\"lng\"\r\n\r\n")
        append("\(lng)\r\n")

        if let imageData = image.jpegData(compressionQuality: 0.7) {
            append("--\(boundary)\r\n")
            append("Content-Disposition: form-data; name=\"image\"; filename=\"proof.jpg\"\r\n")
            append("Content-Type: image/jpeg\r\n\r\n")
            data.append(imageData)
            append("\r\n")
        }

        append("--\(boundary)--\r\n")
        return data
    }

}


