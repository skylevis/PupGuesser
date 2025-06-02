//
//  Button+Style.swift
//  PupGuesser
//
//  Created by See Soon Kiat on 3/6/25.
//

import Foundation
import SwiftUI

// MARK: - Custom Button Styles

struct PrimaryButtonStyle: ButtonStyle {
    let titleColor: Color
    let backgroundColor: Color
    let font: Font
    
    init(titleColor: Color = .white, backgroundColor: Color = .blue, font: Font = .system(size: 32, weight: .heavy)) {
        self.titleColor = titleColor
        self.backgroundColor = backgroundColor
        self.font = font
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(font)
            .foregroundColor(titleColor)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(backgroundColor)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct OutlinedButtonStyle: ButtonStyle {
    let borderColor: Color
    let titleColor: Color
    let font: Font
    
    init(borderColor: Color = .primary, titleColor: Color = .primary, font: Font = .system(size: 32, weight: .bold)) {
        self.borderColor = borderColor
        self.titleColor = titleColor
        self.font = font
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(font)
            .foregroundColor(titleColor)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Custom Button Views

struct PrimaryButton: View {
    let title: String?
    let image: Image?
    let action: () -> Void
    
    // Style customization
    let titleColor: Color
    let backgroundColor: Color
    let font: Font
    
    init(title: String? = nil,
         image: Image? = nil,
         titleColor: Color = .white,
         backgroundColor: Color = .blue,
         font: Font = .system(size: 24, weight: .bold),
         action: @escaping () -> Void) {
        self.title = title
        self.image = image
        self.titleColor = titleColor
        self.backgroundColor = backgroundColor
        self.font = font
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                if let image = image {
                    image
                        .foregroundColor(titleColor)
                }
                
                if let title = title {
                    Text(title)
                }
            }
        }
        .buttonStyle(PrimaryButtonStyle(
            titleColor: titleColor,
            backgroundColor: backgroundColor,
            font: font
        ))
    }
}

struct OutlinedButton: View {
    let title: String?
    let image: Image?
    let action: () -> Void
    
    // Style customization
    let borderColor: Color
    let titleColor: Color
    let font: Font
    
    init(title: String? = nil,
         image: Image? = nil,
         borderColor: Color = .primary,
         titleColor: Color = .primary,
         font: Font = .system(size: 24, weight: .semibold),
         action: @escaping () -> Void) {
        self.title = title
        self.image = image
        self.borderColor = borderColor
        self.titleColor = titleColor
        self.font = font
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                if let image = image {
                    image
                        .foregroundColor(titleColor)
                }
                
                if let title = title {
                    Text(title)
                }
            }
        }
        .buttonStyle(OutlinedButtonStyle(
            borderColor: borderColor,
            titleColor: titleColor,
            font: font
        ))
    }
}

// MARK: - View Extensions for Button Modifiers

extension View {
    func primaryButtonStyle(titleColor: Color = .white, backgroundColor: Color = .blue, font: Font = .system(size: 32, weight: .heavy)) -> some View {
        self.buttonStyle(PrimaryButtonStyle(titleColor: titleColor, backgroundColor: backgroundColor, font: font))
    }
    
    func outlinedButtonStyle(borderColor: Color = .primary, titleColor: Color = .primary, font: Font = .system(size: 32, weight: .bold)) -> some View {
        self.buttonStyle(OutlinedButtonStyle(borderColor: borderColor, titleColor: titleColor, font: font))
    }
}

// MARK: - Usage Examples

struct ButtonExamplesView: View {
    var body: some View {
        VStack(spacing: 20) {
            // Using custom button views
            PrimaryButton(title: "Primary Button") {
                print("Primary button tapped")
            }
            
            OutlinedButton(title: "Outlined Button") {
                print("Outlined button tapped")
            }
            
            // Using button styles with regular Button
            Button("Styled Primary") {
                print("Styled primary tapped")
            }
            .primaryButtonStyle()
            
            Button("Styled Outlined") {
                print("Styled outlined tapped")
            }
            .outlinedButtonStyle()
            
            // With images
            PrimaryButton(
                title: "With Image",
                image: Image(systemName: "heart.fill")
            ) {
                print("Primary with image tapped")
            }
            
            OutlinedButton(
                title: "With Image",
                image: Image(systemName: "star.fill")
            ) {
                print("Outlined with image tapped")
            }
            
            // Custom colors
            PrimaryButton(
                title: "Custom Colors",
                titleColor: .white,
                backgroundColor: .red
            ) {
                print("Custom colored button tapped")
            }
            
            OutlinedButton(
                title: "Custom Border",
                borderColor: .green,
                titleColor: .green
            ) {
                print("Custom bordered button tapped")
            }
        }
        .padding()
    }
}
