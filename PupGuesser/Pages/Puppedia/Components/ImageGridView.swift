//
//  ImageGridView.swift
//  PupGuesser
//
//  Created by See Soon Kiat on 3/6/25.
//

import SwiftUI

struct ImageGridView: View {
    @ObservedObject var viewModel: PuppediaViewModel
    
    private var columns: [GridItem] {
        let columnCount = viewModel.imageUrls.count > 10 ? 2 : 1
        return Array(repeating: GridItem(.flexible(), spacing: 8), count: columnCount)
    }
    
    var body: some View {
        ZStack {
            // Background that extends to fill entire space
            Color.accentPrimary
                .ignoresSafeArea(.container, edges: .bottom)
            
            // Content with proper safe area handling
            ScrollView {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(viewModel.imageUrls, id: \.self) { imageUrl in
                        BreedImageView(imageUrl: imageUrl)
                    }
                }
                .padding(.all, 8)
                .padding(.bottom, 20) // Extra safe area padding
            }
        }
        .cornerRadius(8)
    }
}

// MARK: - Custom Row Views

struct BreedImageView: View {
    let imageUrl: String
    
    var body: some View {
        AsyncImage(url: URL(string: imageUrl)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 120, maxHeight: 200)
                .clipped()
        } placeholder: {
            Image(systemName: "photo")
                .font(.system(size: 40))
                .foregroundColor(.gray)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 120, maxHeight: 200)
                .background(Color.gray.opacity(0.2))
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .aspectRatio(1.0, contentMode: .fit)
    }
}
