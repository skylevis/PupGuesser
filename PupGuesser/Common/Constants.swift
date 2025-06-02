//
//  Constants.swift
//  PupGuesser
//
//  Created by See Soon Kiat on 3/6/25.
//

import Foundation
import SwiftUI

class Constants {
    static let baseURLString = "https://dog.ceo/api"
}

extension Color {
    static let contentPrimary = Color(hex: "8B4513")
    static let contentSecondary = Color(hex: "A89F91")
    static let contentInverse = Color(hex: "FFFFFF")
    static let basePrimary = Color(hex: "FAEBD7")
    static let baseSecondary = Color(hex: "A0522D")
    static let selectionPrimary = Color(hex: "FFA94D")
    static let accentPrimary = Color(hex: "FFE5B4")
    
    /// Initialise a color using a 6-lettered hexadecimal code
    /// Example: FFFFFF for white color
    /// - Parameter hex: 6 digit hexadecimal color code
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexSanitized.hasPrefix("#") {
            hexSanitized.removeFirst()
        }
        
        guard hexSanitized.count == 6,
              let rgbValue = UInt64(hexSanitized, radix: 16) else {
            self.init(.gray)
            return
        }
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}
