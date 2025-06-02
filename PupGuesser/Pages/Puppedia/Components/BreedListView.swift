//
//  BreedListView.swift
//  PupGuesser
//
//  Created by See Soon Kiat on 3/6/25.
//

import SwiftUI

struct BreedListView: View {
    @ObservedObject var viewModel: PuppediaViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Header - always safe
                if let totalBreeds = viewModel.breedList {
                    BreedCountHeaderView(
                        discovered: viewModel.discoveredList.count,
                        total: totalBreeds.count
                    )
                    .padding(.bottom, 8)
                }
                
                // Breed List with selection highlighting
                List(viewModel.discoveredList, id: \.id) { breed in
                    BreedRowView(
                        breedName: breed.displayName,
                        isSelected: viewModel.selectedBreed?.id == breed.id
                    )
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .listRowSeparatorTint(.contentSecondary)
                    .listRowBackground(Color.clear)
                    .onTapGesture {
                        viewModel.selectedBreed = breed
                        _ = viewModel.fetchImageUrls(for: breed)
                    }
                }
                .listStyle(PlainListStyle())
                .background(Color.clear)
                .safeAreaInset(edge: .bottom) {
                    // Invisible spacer to prevent content in unsafe areas
                    Color.clear.frame(height: geometry.safeAreaInsets.bottom)
                }
            }
        }
    }
}

// MARK: - Custom Row Views

struct BreedCountHeaderView: View {
    let discovered: Int
    let total: Int
    
    var body: some View {
        HStack {
            Text("Discovered: \(discovered) / \(total)")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.contentInverse)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            Spacer()
        }
        .padding(.all, 8)
        .background(Color.baseSecondary)
        .cornerRadius(12)
        .frame(height: 40)
    }
}

struct BreedRowView: View {
    let breedName: String
    let isSelected: Bool
    
    var body: some View {
        HStack {
            Text(breedName)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(isSelected ? .contentInverse : .contentPrimary)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            // Selection indicator
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.accentPrimary)
                    .font(.system(size: 16))
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 10)
        .background(isSelected ? Color.selectionPrimary : Color.contentInverse)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(isSelected ? Color.accentPrimary : Color.clear, lineWidth: 2)
        )
        .contentShape(Rectangle())
        .cornerRadius(4)
    }
}
