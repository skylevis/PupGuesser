//
//  UIButton+Styles.swift
//  PupGuesser
//
//  Created by See Soon Kiat on 31/5/25.
//

import UIKit

extension UIButton {
    static func primaryButton(title: String?, image: UIImage?) -> UIButton {
        let button = UIButton(type: .custom).primary()
        button.setTitle(title, for: .normal)
        if let image {
            button.setImage(image, for: .normal)
            button.tintColor = .selectionPrimary
        }
        return button
    }
    
    static func outlinedButton(title: String?, image: UIImage?) -> UIButton {
        let button = UIButton(type: .custom).outlined()
        button.setTitle(title, for: .normal)
        if let image {
            button.setImage(image, for: .normal)
            button.tintColor = .selectionPrimary
        }
        return button
    }
    
    func primary(titleColor: UIColor = .contentInverse, background: UIColor = .selectionPrimary, font: UIFont = .systemFont(ofSize: 18, weight: .heavy)) -> Self {
        var config = UIButton.Configuration.filled()
        config.titlePadding = 20
        config.imagePadding = 12
        config.baseBackgroundColor = background
        self.configuration = config
        self.setTitleColor(titleColor, for: .normal)
        self.layer.cornerRadius = 12
        self.titleLabel?.font = font
        self.layer.borderWidth = 0
        return self
    }
    
    func outlined(borderColor: UIColor = .contentPrimary, titleColor: UIColor = .contentPrimary, font: UIFont = .systemFont(ofSize: 18, weight: .bold)) -> Self {
        var config = UIButton.Configuration.bordered()
        config.titlePadding = 20
        config.imagePadding = 12
        config.baseBackgroundColor = .clear
        self.configuration = config
        self.setTitleColor(titleColor, for: .normal)
        self.layer.cornerRadius = 12
        self.titleLabel?.font = font
        self.layer.borderWidth = 2
        self.layer.borderColor = borderColor.cgColor
        return self
    }
}
