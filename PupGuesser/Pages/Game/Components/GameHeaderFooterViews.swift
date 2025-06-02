//
//  GameHeaderFooterViews.swift
//  PupGuesser
//
//  Created by See Soon Kiat on 3/6/25.
//

import SwiftUI

// MARK: - Game Header

struct GameHeaderView: View {
    let questionNumber: Int
    let onExit: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Exit button row
            HStack {
                Button(action: onExit) {
                    HStack(spacing: 4) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16))
                        Text("End")
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .foregroundColor(.contentPrimary)
                }
                Spacer()
            }
            .padding(.horizontal, 8)
            .padding(.top, 8)
            
            // Title with logo (centered)
            HStack(spacing: 8) {
                Image(systemName: "pawprint.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.orange)
                    .rotationEffect(.degrees(333)) // 1.85 radians ≈ 333 degrees
                
                Text("Question \(questionNumber)")
                    .font(.system(size: 36, weight: .heavy))
                    .foregroundColor(.contentPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .padding(.top, 8)
    }
}

// MARK: - Game Footer

struct GameFooterView: View {
    let score: Int
    let streak: Int
    
    var body: some View {
        HStack {
            Text("Current Streak: \(streak)")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.contentPrimary)
            
            Spacer()
            
            Text("Current Score: \(score)")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.contentPrimary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}
