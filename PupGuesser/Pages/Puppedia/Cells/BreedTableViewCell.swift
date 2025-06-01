//
//  BreedTableViewCell.swift
//  PupGuesser
//
//  Created by See Soon Kiat on 1/6/25.
//

import UIKit

class BreedTableViewCell: UITableViewCell {
    private lazy var breedLabel = createBreedLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(breedLabel)
        breedLabel.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview().inset(8)
        }
    }
    
    func updateCell(breedName: String) {
        breedLabel.text = breedName
    }
    
    private func createBreedLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .contentPrimary
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textAlignment = .left
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        return label
    }
}
