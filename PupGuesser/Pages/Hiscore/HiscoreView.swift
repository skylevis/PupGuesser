//
//  HiscoreView.swift
//  PupGuesser
//
//  Created by See Soon Kiat on 3/6/25.
//

import SwiftUI

struct HiscoreView: View {
    @StateObject private var viewModel = HiscoreViewModel()
    @State private var hiscores: HiScores
    @State private var showingResetAlert = false
    @Environment(\.dismiss) private var dismiss
    
    init() {
        let vm = HiscoreViewModel()
        self._viewModel = StateObject(wrappedValue: vm)
        self._hiscores = State(initialValue: vm.fetchScores())
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            // Highest Score
            HStack {
                Text("Highest Score: ")
                    .foregroundColor(.contentPrimary)
                    .font(.system(size: 28, weight: .regular))
                + Text("\(hiscores.score)")
                    .foregroundColor(.selectionPrimary)
                    .font(.system(size: 28, weight: .semibold))
                Spacer()
            }
            .font(.title2)
            
            // Longest Streak
            HStack {
                Text("Longest Streak: ")
                    .foregroundColor(.contentPrimary)
                    .font(.system(size: 28, weight: .regular))
                + Text("\(hiscores.streak)")
                    .foregroundColor(.selectionPrimary)
                    .font(.system(size: 28, weight: .semibold))
                Spacer()
            }
            .font(.title2)
            
            Spacer()
            
            // Reset Button
            OutlinedButton(title: "Reset", image: Image(systemName: "arrow.counterclockwise"), borderColor: .contentPrimary, titleColor: .selectionPrimary, font: .system(size: 24, weight: .semibold)) {
                showingResetAlert = true
            }
            .padding()
            .background(Color.clear)
        }
        .padding(24)
        .background(Color.basePrimary)
        .appNavigationBar(title: "Hi-scores") { dismiss() }
        .alert("Are you sure?", isPresented: $showingResetAlert) {
            Button("Yes", role: .destructive) {
                viewModel.resetGame()
                hiscores = viewModel.fetchScores()
            }
            Button("No", role: .cancel) { }
        } message: {
            Text("All scores and puppedia will be reset!")
        }
    }
}

#Preview {
    HiscoreView()
}
