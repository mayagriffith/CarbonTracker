//
//  CarbonAPIService.swift
//  CarbonTracker
//
//  Created by Maya Griffith on 1/11/25.
//

import Foundation

class CarbonAPIService {
    private let apiKey = "OJTZJrQ0vgnp5cpLJ9xCg" // Replace with your API key
    private let baseURL = "https://www.carboninterface.com/api/v1"

    func fetchElectricityEstimate(
        electricityUnit: String,
        electricityValue: Double,
        country: String,
        state: String?,
        completion: @escaping (Result<Double, Error>) -> Void
    ) {
        guard let url = URL(string: "\(baseURL)/estimates") else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Prepare the payload
        let payload: [String: Any] = [
            "type": "electricity",
            "electricity_unit": electricityUnit,
            "electricity_value": electricityValue,
            "country": country,
            "state": state ?? ""
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload)
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
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            // Log the raw response for debugging
            let responseString = String(data: data, encoding: .utf8) ?? "Unable to decode response"
            print("Raw Response: \(responseString)")

            do {
                // Parse the JSON response
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let attributes = (json["data"] as? [String: Any])?["attributes"] as? [String: Any],
                   let carbonKg = attributes["carbon_kg"] as? Double {
                    completion(.success(carbonKg))
                } else if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                          let errorMessage = json["message"] as? String {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                } else {
                    throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON structure"])
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
