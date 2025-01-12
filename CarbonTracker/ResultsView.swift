//
//  ResultsView.swift
//  CarbonTracker
//
//  Created by Maya Griffith on 1/11/25.
//

import SwiftUI

struct ResultsView: View {
    let totalCarbon: Double

    var body: some View {
        VStack {
            Text("Your Total Carbon Footprint")
                .font(.largeTitle)
                .padding()
            Text("\(totalCarbon, specifier: "%.2f") kg CO₂")
                .font(.title)
                .padding()
            Text("Here are some tips to lower your emissions:")
                .multilineTextAlignment(.center)
                .padding()

            // Example tips
            List {
                Text("🌱 Replace one meat-based meal with a plant-based meal.")
                Text("🚴 Bike instead of driving for short distances.")
                Text("🔌 Turn off unused appliances to save energy.")
            }
        }
        .navigationTitle("Results")
    }
}
