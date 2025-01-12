//
//  DashboardView.swift
//  CarbonTracker
//
//  Created by Maya Griffith on 1/11/25.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("🌱")
                    .font(.system(size: 50))
                    .padding(.bottom, 10)

                Text("Your Daily EcoBudget")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)

                Text("You have 8.5 kg CO₂ remaining")
                    .font(.headline)
                    .padding(.bottom, 10)

                ProgressView(value: 8.5, total: 10)
                    .padding(.horizontal)

                Spacer()

                // Navigation Link to Activity Tracker
                NavigationLink(destination: ActivityTrackerView()) {
                    Text("Log Activity")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                // Navigation Link to Questionnaire
                NavigationLink(destination: QuestionnaireView()) {
                    Text("Take Questionnaire")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                // Navigation Link to ChatGPTView
                NavigationLink(destination: ChatGPTView()) {
                    Text("Chat with AI")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
        }
    }
}
