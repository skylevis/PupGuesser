//
//  Bundle+Image.swift
//  PupGuesser
//
//  Created by See Soon Kiat on 31/5/25.
//

import UIKit

extension UIImageView {
    static func image(named name: String) -> UIImageView {
        guard let image = UIImage(named: name) else {
            assertionFailure("Failed to find image of name - \(name)")
            return UIImageView()
        }
        return UIImageView(image: image)
    }
}
