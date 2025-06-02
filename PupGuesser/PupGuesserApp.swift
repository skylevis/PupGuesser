//
//  PupGuesserApp.swift
//  PupGuesser
//
//  Created by See Soon Kiat on 3/6/25.
//

import SwiftUI

@main
struct PupGuesserApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MenuView()
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .preferredColorScheme(.light) // Only configured for light mode
        }
    }
}

// MARK: - Supporting iOS-specific configurations

extension PupGuesserApp {
    // Add any app-level configurations here
    static func configureAppearance() {
        // Configure navigation bar appearance if needed
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor.label
        ]
        
        // Configure other UI elements
        UITabBar.appearance().backgroundColor = UIColor.systemBackground
    }
}
