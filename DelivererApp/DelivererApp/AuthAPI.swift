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

    func login(email: String,
               password: String,
               completion: @escaping (Result<LoginResponse, Error>) -> Void) {

        guard let url = URL(string: "\(baseURL)/auth/login") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "email": email,
            "password": password
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else { return }

            do {
                let decoded = try JSONDecoder().decode(LoginResponse.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }

        }.resume()
    }

    func getTours(token: String,
                  completion: @escaping ([Tour]) -> Void) {

        guard let url = URL(string: "\(baseURL)/tours") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else { return }

            if let tours = try? JSONDecoder().decode([Tour].self, from: data) {
                completion(tours)
            }
        }.resume()
    }

    func sendProof(token: String,
                   tourId: String,
                   image: UIImage,
                   lat: Double,
                   lng: Double,
                   completion: @escaping () -> Void) {

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
            tourId: tourId,
            image: image,
            lat: lat,
            lng: lng
        )

        request.httpBody = body

        URLSession.shared.dataTask(with: request) { _, _, _ in
            completion()
        }.resume()
    }

    private func createMultipartBody(boundary: String,
                                     tourId: String,
                                     image: UIImage,
                                     lat: Double,
                                     lng: Double) -> Data {

        var data = Data()

        func append(_ string: String) {
            data.append(string.data(using: .utf8)!)
        }

        append("--\(boundary)\r\n")
        append("Content-Disposition: form-data; name=\"tourId\"\r\n\r\n")
        append("\(tourId)\r\n")

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


