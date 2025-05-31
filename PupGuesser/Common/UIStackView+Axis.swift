//
//  UIStackView+Axis.swift
//  PupGuesser
//
//  Created by See Soon Kiat on 31/5/25.
//

import UIKit

extension UIStackView {
    convenience init(axis: NSLayoutConstraint.Axis, spacing: CGFloat = 0) {
        self.init(frame: .zero)
        self.axis = axis
        self.spacing = spacing
    }
}
