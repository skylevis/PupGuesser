//
//  Constants.swift
//  PupGuesser
//
//  Created by See Soon Kiat on 31/5/25.
//

import UIKit

extension UIColor {
    static let contentPrimary = UIColor(hex: "8B4513")
    static let contentSecondary = UIColor(hex: "A89F91")
    static let contentInverse = UIColor(hex: "FFFFFF")
    static let basePrimary = UIColor(hex: "FAEBD7")
    static let selectionPrimary = UIColor(hex: "FFA94D")
    static let accentPrimary = UIColor(hex: "FFE5B4")
    
    /// Initialise a color using a 6-lettered hexadecimal code
    /// Example: FFFFFF for white color
    /// - Parameter hex: 6 digit hexadecimal color code
    convenience init(hex: String) {
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
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
