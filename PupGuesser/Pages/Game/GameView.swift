//
//  GameView.swift
//  PupGuesser
//
//  Created by See Soon Kiat on 3/6/25.
//

import SwiftUI

struct GameView: View {
    @StateObject private var viewModel: GameViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showExitAlert = false
    
    init(viewModel: GameViewModel = GameViewModel()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            Color.basePrimary
                .ignoresSafeArea(.all)
            
            VStack(spacing: 16) {
                // Main Card
                VStack(spacing: 0) {
                    // Header with title and exit button
                    GameHeaderView(
                        questionNumber: viewModel.currentRound,
                        onExit: { showExitAlert = true }
                    )
                    
                    // Game content area
                    GameContentView(viewModel: viewModel)
                    
                    // Footer with scores
                    GameFooterView(
                        score: viewModel.score,
                        streak: viewModel.streak
                    )
                }
                .background(Color.accentPrimary)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.contentPrimary, lineWidth: 0.5)
                )
                .shadow(color: .black.opacity(0.1), radius: 8, x: 4, y: 4)
                .padding(.horizontal, 24)
            }
        }
        .navigationBarHidden(true)
        .alert("Are you sure?", isPresented: $showExitAlert) {
            Button("Yes", role: .destructive) {
                dismiss()
            }
            Button("No", role: .cancel) { }
        } message: {
            Text("The game will end and scores will be recorded.")
        }
        .onAppear {
            viewModel.loadNextRound()
        }
    }
}



// MARK: - Game Content

struct GameContentView: View {
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        VStack {
            switch viewModel.gameState {
            case .loading:
                GameLoadingView()
            case .error:
                GameErrorView {
                    viewModel.loadNextRound()
                }
            case .playing:
                if let gameRound = viewModel.currentGameRound {
                    GameRoundView(
                        gameRound: gameRound,
                        selectedOption: viewModel.selectedOption,
                        onOptionSelected: { index in
                            _ = viewModel.submitAnswer(index: index)
                        },
                        onNext: {
                            viewModel.loadNextRound()
                        }
                    )
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 8)
    }
}

#Preview {
    GameView()
}
