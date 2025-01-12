//
//  QuestionnaireView.swift
//  CarbonTracker
//
//  Created by Maya Griffith on 1/11/25.
//
import SwiftUI

struct QuestionnaireView: View {
    // Track the current step
    @State private var currentStep: Int = 0

    // User inputs for electricity
    @State private var houseSize = "Small"
    @State private var hoursOfLight: String = ""

    // User inputs for travel
    @State private var travelEntries: [TravelEntry] = [TravelEntry(transportMode: "Car", distance: "")]
    @State private var electricityCarbon: Double? = nil
    @State private var travelCarbon: Double? = nil

    // Loading state
    @State private var isLoading: Bool = false

    // API Service
    private let apiService = CarbonAPIService()

    var body: some View {
        VStack {
            // Display the current step for debugging
            Text("Current Step: \(currentStep)")
                .font(.caption)
                .foregroundColor(.gray)
                .padding()

            if currentStep == 0 {
                electricityStep
            } else if currentStep == 1 {
                travelStep
            } else {
                resultsStep
            }
        }
        .padding()
    }

    // MARK: Electricity Step
    private var electricityStep: some View {
        VStack {
            Text("Step 1: Electricity Usage")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            Picker("How big is your house?", selection: $houseSize) {
                Text("Small").tag("Small")
                Text("Medium").tag("Medium")
                Text("Large").tag("Large")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            TextField("How many hours were your lights on today?", text: $hoursOfLight)
                .keyboardType(.numberPad)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            if isLoading {
                ProgressView("Calculating electricity...")
                    .padding()
            }

            Button(action: calculateElectricityCarbon) {
                Text(isLoading ? "Loading..." : "Next")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isLoading ? Color.gray : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            .disabled(isLoading || hoursOfLight.isEmpty)
        }
    }

    // MARK: Travel Step
    private var travelStep: some View {
        VStack {
            Text("Step 2: Travel Emissions")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            ForEach($travelEntries) { $entry in
                HStack {
                    Picker("Mode", selection: $entry.transportMode) {
                        Text("Car").tag("Car")
                        Text("Train").tag("Train")
                        Text("Bus").tag("Bus")
                        Text("Plane").tag("Plane")
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: 100)

                    TextField("Distance (miles)", text: $entry.distance)
                        .keyboardType(.numberPad)
                        .frame(maxWidth: .infinity)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button(action: {
                        if let index = travelEntries.firstIndex(of: entry) {
                            travelEntries.remove(at: index)
                        }
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.red)
                    }
                }
                .padding(.vertical, 4)
            }

            Button(action: {
                travelEntries.append(TravelEntry(transportMode: "Car", distance: ""))
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Another Mode")
                }
                .foregroundColor(.blue)
            }
            .padding()

            if isLoading {
                ProgressView("Calculating travel...")
                    .padding()
            }

            Button(action: calculateTravelCarbon) {
                Text(isLoading ? "Loading..." : "Next")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isLoading ? Color.gray : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            .disabled(isLoading || travelEntries.isEmpty || travelEntries.contains(where: { $0.distance.isEmpty }))
        }
    }

    // MARK: Results Step
    private var resultsStep: some View {
        VStack {
            Text("Your Daily Carbon Footprint")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            if let electricityCarbon = electricityCarbon {
                Text("Electricity: \(String(format: "%.2f", electricityCarbon)) kg CO₂")
                    .font(.headline)
                    .padding()
            }

            if let travelCarbon = travelCarbon {
                Text("Travel: \(String(format: "%.2f", travelCarbon)) kg CO₂")
                    .font(.headline)
                    .padding()
            }

            if let totalCarbon = totalCarbon {
                Divider()
                Text("Total: \(String(format: "%.2f", totalCarbon)) kg CO₂")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .padding()
            }

            Button(action: resetQuestionnaire) {
                Text("Start Over")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
    }

    // MARK: Helper Methods
    private func calculateElectricityCarbon() {
        guard let hours = Double(hoursOfLight), hours > 0 else { return }
        let kWh = estimateKWh(for: houseSize, hours: hours)
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isLoading = false
            self.electricityCarbon = kWh * 0.5 // Mock carbon output
            self.currentStep = 1 // Move to the next step
        }
    }

    private func calculateTravelCarbon() {
        guard !travelEntries.isEmpty else { return }
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isLoading = false
            self.travelCarbon = 20.0 // Mock total travel carbon
            self.currentStep = 2 // Move to results step
        }
    }

    private func estimateKWh(for size: String, hours: Double) -> Double {
        let baseUsage: Double
        switch size {
        case "Small": baseUsage = 0.2
        case "Medium": baseUsage = 0.3
        case "Large": baseUsage = 0.4
        default: baseUsage = 0.2
        }
        return baseUsage * hours
    }

    private func resetQuestionnaire() {
        currentStep = 0
        hoursOfLight = ""
        travelEntries = [TravelEntry(transportMode: "Car", distance: "")]
        electricityCarbon = nil
        travelCarbon = nil
    }

    private var totalCarbon: Double? {
        guard let electricity = electricityCarbon, let travel = travelCarbon else { return nil }
        return electricity + travel
    }
}

// MARK: Travel Entry Model
struct TravelEntry: Identifiable, Equatable {
    let id = UUID()
    var transportMode: String
    var distance: String
}
