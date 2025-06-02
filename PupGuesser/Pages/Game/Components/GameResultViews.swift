//
//  GameResultViews.swift
//  PupGuesser
//
//  Created by See Soon Kiat on 3/6/25.
//

import SwiftUI

// MARK: - Game Result View

struct GameResultView: View {
    let isCorrect: Bool
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack(spacing: 8) {
                Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(isCorrect ? .green : .red)
                
                Text(isCorrect ? "Correct!" : "Oops! Try again!")
                    .font(.system(size: isCorrect ? 20 : 16, weight: isCorrect ? .bold : .medium))
                    .foregroundColor(isCorrect ? .green : .red)
            }
            
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}

// MARK: - Game Loading View

struct GameLoadingView: View {
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            ProgressView()
                .scaleEffect(2.0)
                .progressViewStyle(CircularProgressViewStyle(tint: .contentPrimary))
            
            Text("Fetching your next pup...")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.contentPrimary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            Spacer()
        }
    }
}

// MARK: - Game Error View

struct GameErrorView: View {
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            // Error Image (using system image as placeholder)
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 80))
                .foregroundColor(.orange)
            
            Text("Oops! Something went wrong!")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.contentPrimary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            Button(action: onRetry) {
                Text("Retry")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.blue)
                    .frame(width: 120, height: 44)
                    .background(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue, lineWidth: 2)
                    )
            }
            
            Spacer()
        }
    }
}
