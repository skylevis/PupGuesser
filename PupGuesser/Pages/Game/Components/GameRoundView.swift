//
//  GameRoundView.swift
//  PupGuesser
//
//  Created by See Soon Kiat on 3/6/25.
//

import SwiftUI

struct GameRoundView: View {
    let gameRound: GameRound
    let selectedOption: Breed?
    let onOptionSelected: (Int) -> Void
    let onNext: () -> Void
    
    private var isAnswered: Bool {
        selectedOption != nil
    }
    
    private var isCorrect: Bool {
        guard let selected = selectedOption else { return false }
        return selected.id == gameRound.selectedBreed.id
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Puppy Image
            AsyncImage(url: URL(string: gameRound.imageData.url)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 240, height: 240)
                    .clipped()
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 240, height: 240)
                    .overlay(
                        ProgressView()
                            .scaleEffect(1.5)
                    )
            }
            .cornerRadius(20)
            .padding(.top, 16)
            
            // Question
            Text("Which breed is this?")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.contentPrimary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            // Options Grid
            GameOptionsGrid(
                options: gameRound.options,
                selectedOption: selectedOption,
                correctOption: gameRound.selectedBreed,
                isAnswered: isAnswered,
                onOptionSelected: onOptionSelected
            )
            
            // Result Feedback
            if isAnswered {
                GameResultView(isCorrect: isCorrect)
            }
            
            Spacer()
            
            // Next Button
            if isAnswered {
                PrimaryButton(title: "Next", titleColor: .contentInverse, backgroundColor: .selectionPrimary, font: .system(size: 18, weight: .bold), action: onNext)
                    .padding(.all, 16)
            }
        }
    }
}

// MARK: - Game Options Grid

struct GameOptionsGrid: View {
    let options: [Breed]
    let selectedOption: Breed?
    let correctOption: Breed
    let isAnswered: Bool
    let onOptionSelected: (Int) -> Void
    
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(Array(options.enumerated()), id: \.offset) { index, option in
                GameOptionButton(
                    option: option,
                    isSelected: selectedOption?.id == option.id,
                    isCorrect: option.id == correctOption.id,
                    isAnswered: isAnswered,
                    onTap: {
                        if !isAnswered {
                            onOptionSelected(index)
                        }
                    }
                )
            }
        }
        .padding(.horizontal, 8)
    }
}

// MARK: - Game Option Button

struct GameOptionButton: View {
    let option: Breed
    let isSelected: Bool
    let isCorrect: Bool
    let isAnswered: Bool
    let onTap: () -> Void
    
    private var backgroundColor: Color {
        if !isAnswered { return .clear }
        if isSelected {
            return isCorrect ? .green : .red
        } else if isCorrect {
            return .green
        }
        return .clear
    }
    
    private var textColor: Color {
        if !isAnswered { return .contentPrimary }
        if (isSelected || isCorrect) && backgroundColor != .clear {
            return .white
        }
        return .contentPrimary
    }
    
    var body: some View {
        Button(action: onTap) {
            Text(option.displayName)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(textColor)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.contentPrimary, lineWidth: 2)
                )
                .cornerRadius(12)
        }
        .disabled(isAnswered)
    }
}
