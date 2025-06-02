//
//  MenuView.swift
//  PupGuesser
//
//  Created by See Soon Kiat on 3/6/25.
//

import SwiftUI

// MARK: - Simple TitleView
struct TitleView: View {
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Image("LogoImage")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 160, height: 160)
                
                Image("TitleCard")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .offset(y: -32)
            }
        }
    }
}

// MARK: - Simple MenuView
struct MenuView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Spacer()
                
                TitleView()
                
                NavigationLink("Play Game", destination: GameView())
                    .buttonStyle(PrimaryButtonStyle(titleColor: .contentInverse, backgroundColor: .selectionPrimary, font: .system(size: 32, weight: .bold)))
                
                
                NavigationLink(destination: PuppediaView()) {
                    HStack(spacing: 12) {
                        Image(systemName: "book.fill")
                        Text("My Puppedia")
                    }
                }
                .buttonStyle(OutlinedButtonStyle(borderColor: .contentPrimary, titleColor: .selectionPrimary, font: .system(size: 32, weight: .semibold)))
                
                NavigationLink(destination: HiscoreView()) {
                    HStack(spacing: 12) {
                        Image(systemName: "trophy.fill")
                        Text("Hi-score")
                    }
                }
                .buttonStyle(OutlinedButtonStyle(borderColor: .contentPrimary, titleColor: .selectionPrimary, font: .system(size: 32, weight: .semibold)))
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .background(Color.basePrimary)
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    MenuView()
}
