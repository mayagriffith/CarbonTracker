//
//  ChatGPTView.swift
//  CarbonTracker
//
//  Created by Maya Griffith on 1/11/25.
//


import SwiftUI
import Foundation

struct ChatGPTView: View {
    @State private var suggestionsVisible = true
    @State private var userQuestion: String = ""
    @State private var chatGPTResponse: String? = nil
    @State private var isLoading = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if suggestionsVisible {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("🌟 AI-Powered Suggestions")
                            .font(.title)
                            .bold()
                        Text("Here are some tips to reduce your carbon footprint:")
                            .font(.headline)

                        VStack(alignment: .leading, spacing: 5) {
                            Text("🌱 Replace one meat-based meal with a plant-based meal.")
                            Text("🚴 Use public transport or bike instead of driving.")
                            Text("💡 Turn off lights and appliances when not in use.")
                        }
                        .padding(.leading)
                    }
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(10)
                }

                TextField("Ask ChatGPT a question...", text: $userQuestion)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .disabled(isLoading)

                Button(action: askChatGPT) {
                    Text("Ask ChatGPT")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .disabled(userQuestion.isEmpty || isLoading)

                if isLoading {
                    ProgressView("Fetching response...")
                }

                if let response = chatGPTResponse {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("ChatGPT's Response:")
                            .font(.headline)
                            .bold()
                        Text(response)
                            .font(.body)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                    }
                    .padding(.top)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("ChatGPT")
        }
    }

    func askChatGPT() {
        suggestionsVisible = false
        isLoading = true
        chatGPTResponse = nil

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            chatGPTResponse = "Here's a response to your question: \(userQuestion)"
            isLoading = false
        }
    }
}
