//
//  QuestionnaireView.swift
//  CarbonTracker
//
//  Created by Maya Griffith on 1/11/25.
//
import SwiftUI

struct QuestionnaireView: View {
    @State private var houseSize = "Small" // Default value
    @State private var estimatedHours = "4" // Default estimate for small homes
    @State private var customHours: String = ""
    @State private var carbonEstimate: String? = nil
    @State private var isLoading = false

    private let houseSizes = ["Small", "Medium", "Large"] // Options for house sizes
    private let apiService = CarbonAPIService()

    var body: some View {
        VStack {
            Text("Calculate Your Carbon Footprint")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            Text("Let's estimate your electricity usage based on your home's size and light usage.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // House Size Picker
            Picker("How big is your house?", selection: $houseSize) {
                ForEach(houseSizes, id: \.self) { size in
                    Text(size)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            // Estimated Light Usage
            Text("Based on a \(houseSize) house, we estimate:")
            Text("\(estimatedHours) hours of light usage per day.")
                .font(.headline)
                .padding()

            // Optional Custom Input
            TextField("Enter your own estimate of hours (optional)", text: $customHours)
                .keyboardType(.numberPad)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            // Calculate Button
            if isLoading {
                ProgressView("Calculating...")
                    .padding()
            } else {
                Button(action: fetchEstimate) {
                    Text("Calculate Carbon Estimate")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }

            // Show Carbon Estimate or Placeholder
            if let estimate = carbonEstimate {
                Text("Estimated Carbon Footprint:")
                    .font(.headline)
                    .padding(.top)
                Text("\(estimate) kg CO₂")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            } else {
                Text("Your carbon estimate will appear here.")
                    .foregroundColor(.gray)
                    .padding(.top)
            }

            Spacer()
        }
        .padding()
        .onChange(of: houseSize) { newValue in
            updateEstimatedHours(for: newValue)
        }
    }

    // Update estimated hours based on house size
    func updateEstimatedHours(for size: String) {
        switch size {
        case "Small":
            estimatedHours = "4"
        case "Medium":
            estimatedHours = "6"
        case "Large":
            estimatedHours = "8"
        default:
            estimatedHours = "4"
        }
    }

    // Fetch Carbon Estimate
    func fetchEstimate() {
        let hours = Int(customHours) ?? Int(estimatedHours) ?? 0 // Use custom input if provided

        guard hours > 0 else {
            carbonEstimate = "Please enter a valid number of hours."
            return
        }

        let electricityValue = Double(hours) * 0.6 // Assuming ~0.6 kWh per hour for lighting

        isLoading = true
        carbonEstimate = nil // Clear previous estimate

        apiService.fetchElectricityEstimate(
            electricityUnit: "kwh",
            electricityValue: electricityValue,
            country: "us",
            state: "fl"
        ) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let carbonKg):
                    carbonEstimate = String(format: "%.2f", carbonKg)
                case .failure(let error):
                    carbonEstimate = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
}
