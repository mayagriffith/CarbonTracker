//
//  CarbonAPIService.swift
//  CarbonTracker
//
//  Created by Maya Griffith on 1/11/25.
//

import Foundation

class CarbonAPIService {
    private let baseURL = "https://www.carboninterface.com/api/v1/"
    private let apiKey = "YOUR_API_KEY" // Replace with your actual API key

    // Fetch electricity estimate
    func fetchElectricityEstimate(electricityUnit: String, electricityValue: Double, country: String, state: String?, completion: @escaping (Result<Double, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)estimates") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        var body: [String: Any] = [
            "type": "electricity",
            "electricity_unit": electricityUnit,
            "electricity_value": electricityValue,
            "country": country
        ]
        if let state = state {
            body["state"] = state
        }

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let attributes = (json["data"] as? [String: Any])?["attributes"] as? [String: Any],
                   let carbonKg = attributes["carbon_kg"] as? Double {
                    completion(.success(carbonKg))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    // Fetch travel estimate
    func fetchTravelEstimate(distance: Double, transportMethod: String, completion: @escaping (Result<Double, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)estimates") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "type": "vehicle",
            "distance_unit": "mi", // Assuming miles for distance
            "distance_value": distance,
            "vehicle_model_id": transportMethod // Use appropriate identifier for transport type
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let attributes = (json["data"] as? [String: Any])?["attributes"] as? [String: Any],
                   let carbonKg = attributes["carbon_kg"] as? Double {
                    completion(.success(carbonKg))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
