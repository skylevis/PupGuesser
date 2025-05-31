//
//  TitleView.swift
//  PupGuesser
//
//  Created by See Soon Kiat on 31/5/25.
//

import UIKit
import SnapKit

class TitleView: UIView {
    private lazy var titleCard = UIImageView.image(named: "TitleCard")
    private lazy var titleLogo = UIImageView.image(named: "LogoImage")
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        addSubview(titleLogo)
        addSubview(titleCard)
        
        titleLogo.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.width.equalTo(160)
        }
        titleCard.snp.makeConstraints { make in
            make.top.equalTo(titleLogo.snp.bottom).offset(-32)
            make.centerX.bottom.equalToSuperview()
        }
    }
}
