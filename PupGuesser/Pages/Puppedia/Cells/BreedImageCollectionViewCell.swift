//
//  BreedImageCollectionViewCell.swift
//  PupGuesser
//
//  Created by See Soon Kiat on 1/6/25.
//

import UIKit
import SDWebImage

class BreedImageCollectionViewCell: UICollectionViewCell {
    private lazy var imageView = createImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
    }
    
    func setImage(url: String) {
        imageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "placeholderPup"))
    }
    
    private func createImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }
}
