//
//  ContentView.swift
//  CarbonTracker
//
//  Created by Maya Griffith on 1/11/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        WelcomeView() // Entry point is WelcomeView
    }
}

struct EcoBudgetApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

#Preview {
    ContentView()
}
