//
//  AppNavigationBar.swift
//  PupGuesser
//
//  Created by See Soon Kiat on 3/6/25.
//

import SwiftUI

struct AppNavigationBar: ViewModifier {
    let title: String
    let titleColor: Color
    let titleFont: Font
    let backButtonColor: Color
    let backgroundColor: Color
    let onBack: () -> Void
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: onBack) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(backButtonColor)
                            .padding(.leading, 12)
                            .padding(.vertical, 8)
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .font(titleFont)
                        .foregroundColor(titleColor)
                }
            }
            .toolbarBackground(backgroundColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
    }
}

// MARK: - Convenient View Extension

extension View {
    func appNavigationBar(
        title: String,
        titleColor: Color = .contentPrimary,
        titleFont: Font = .system(size: 20, weight: .semibold),
        backButtonColor: Color = .contentPrimary,
        backgroundColor: Color = .basePrimary,
        onBack: @escaping () -> Void
    ) -> some View {
        self.modifier(AppNavigationBar(
            title: title,
            titleColor: titleColor,
            titleFont: titleFont,
            backButtonColor: backButtonColor,
            backgroundColor: backgroundColor,
            onBack: onBack
        ))
    }
}
