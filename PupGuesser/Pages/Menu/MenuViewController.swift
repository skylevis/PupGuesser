//
//  MenuViewController.swift
//  PupGuesser
//
//  Created by See Soon Kiat on 31/5/25.
//

import UIKit

class MenuViewController: UIViewController {
    private lazy var titleView = TitleView()
    private lazy var startGameButton = UIButton.primaryButton(title: "Play Game", image: nil)
    private lazy var puppediaButton = UIButton.outlinedButton(title: "My Puppedia",
                                                              image: UIImage(systemName: "book.fill")?.withRenderingMode(.alwaysTemplate))
    private lazy var hiscoreButton = UIButton.outlinedButton(title: "Hi-score",
                                                             image: UIImage(systemName: "trophy.fill")?.withRenderingMode(.alwaysTemplate))
    private lazy var containerView = UIStackView(axis: .vertical, spacing: 16)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .basePrimary
        view.addSubview(containerView)
        let topSpacer = UIView()
        let bottomSpacer = UIView()
        containerView.addArrangedSubview(topSpacer)
        containerView.addArrangedSubview(titleView)
        containerView.addArrangedSubview(startGameButton)
        containerView.addArrangedSubview(puppediaButton)
        containerView.addArrangedSubview(hiscoreButton)
        containerView.addArrangedSubview(bottomSpacer)
        
        topSpacer.snp.makeConstraints { make in
            make.height.equalTo(bottomSpacer)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        startGameButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        puppediaButton.addTarget(self, action: #selector(viewPuppedia), for: .touchUpInside)
        hiscoreButton.addTarget(self, action: #selector(viewHiscore), for: .touchUpInside)
    }
    
    @objc private func startGame() {
        let gameVC = GameViewController()
        navigationController?.pushViewController(gameVC, animated: true)
    }
    
    @objc private func viewPuppedia() {
        let puppediaVC = PuppediaViewController()
        navigationController?.pushViewController(puppediaVC, animated: true)
    }
    
    @objc private func viewHiscore() {
        
    }
}
