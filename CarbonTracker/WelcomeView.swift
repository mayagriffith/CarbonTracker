//
//  WelcomeView.swift
//  CarbonTracker
//
//  Created by Maya Griffith on 1/11/25.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationStack {
            VStack {
                // Add emojis at the top
                Text("🌎🌱✨")
                    .font(.system(size: 50)) // Adjust size as needed
                    .padding(.bottom, 10) // Space between emojis and title
                
                Text("Welcome to Zero Emission Mission")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                Text("Track your daily carbon footprint and learn how to make eco-friendly choices.")
                    .multilineTextAlignment(.center)
                    .padding()
                
                NavigationLink(destination: DashboardView()) {
                    Text("Get Started")
                        .font(.headline)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}
