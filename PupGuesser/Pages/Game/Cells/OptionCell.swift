//
//  OptionCell.swift
//  PupGuesser
//
//  Created by See Soon Kiat on 1/6/25.
//

import Foundation
import UIKit

class OptionCell: UICollectionViewCell {
    let button = UIButton(type: .system)
    static let optionHeight = 50.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.contentPrimary.cgColor
        button.setTitleColor(.contentPrimary, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.5
        button.titleLabel?.numberOfLines = 1
        button.titleEdgeInsets = .init(top: 0, left: 8, bottom: 0, right: 8)
        contentView.addSubview(button)
        button.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
        button.isUserInteractionEnabled = false
    }
    
    func updateView(option: String) {
        button.setTitle(option, for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(.contentPrimary, for: .normal)
    }
    
    func updateResult(selected: String, correct: String) {
        let option = button.title(for: .normal)
        button.isEnabled = false
        if option == selected {
            if option == correct {
                button.backgroundColor = .systemGreen
                button.setTitleColor(.contentInverse, for: .normal)
            } else {
                button.backgroundColor = .systemRed
                button.setTitleColor(.contentInverse, for: .normal)
            }
        } else if option == correct {
            button.backgroundColor = .systemGreen
            button.setTitleColor(.contentInverse, for: .normal)
        }
    }
}
