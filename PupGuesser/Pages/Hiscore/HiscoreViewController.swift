//
//  HiscoreViewController.swift
//  PupGuesser
//
//  Created by See Soon Kiat on 1/6/25.
//

import Foundation
import UIKit

class HiscoreViewController: UIViewController {
    private lazy var highestScoreLabel = createLabel()
    private lazy var longestStreakLabel = createLabel()
    private lazy var resetButton = createButton()
    private var viewModel: HiscoreViewModelProtocol
    
    init(viewModel: HiscoreViewModelProtocol = HiscoreViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        updateNavigationBar()
        setupView()
        fetchScores()
    }
    
    private func updateNavigationBar() {
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 20, weight: .semibold),
                                                                   .foregroundColor: UIColor.contentPrimary]
        navigationController?.navigationBar.tintColor = .contentPrimary
        navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "chevron.left")
        navigationController?.navigationBar.backItem?.title = ""
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "chevron.left")
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func setupView() {
        title = "Hi-scores"
        view.backgroundColor = .basePrimary
        
        let topSpacer = UIView()
        let bottomSpacer = UIView()
        let stackView = UIStackView(axis: .vertical, spacing: 16)
        stackView.addArrangedSubview(topSpacer)
        stackView.addArrangedSubview(highestScoreLabel)
        stackView.addArrangedSubview(longestStreakLabel)
        stackView.addArrangedSubview(bottomSpacer)
        stackView.addArrangedSubview(resetButton)
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        topSpacer.snp.makeConstraints { make in
            make.height.equalTo(bottomSpacer).multipliedBy(0.3)
        }
    }
    
    private func fetchScores() {
        let hiscores = viewModel.fetchScores()
        highestScoreLabel.attributedText = makeAttributed(label: "Higest Score: ", value: "\(hiscores.score)")
        longestStreakLabel.attributedText = makeAttributed(label: "Longest Streak: ", value: "\(hiscores.streak)")
    }
    
    private func createLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .contentPrimary
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }
    
    private func makeAttributed(label: String, value: String) -> NSAttributedString {
        let label = NSMutableAttributedString(string: label, attributes: [
            .font: UIFont.systemFont(ofSize: 28, weight: .medium),
            .foregroundColor: UIColor.baseSecondary
        ])
        let value = NSMutableAttributedString(string: value, attributes: [
            .font: UIFont.systemFont(ofSize: 28, weight: .bold)
        ])
        label.append(value)
        return label
    }
    
    private func createButton() -> UIButton {
        let button = UIButton.outlinedButton(title: "Reset", image: UIImage(systemName: "arrow.counterclockwise"))
        button.addTarget(self, action: #selector(onReset), for: .touchUpInside)
        button.setTitleColor(.contentPrimary, for: .normal)
        return button
    }
    
    @objc private func onReset() {
        // Confirmation Dialog
        let dialog = UIAlertController(title: "Are you sure?", message: "All scores and puppedia will be reset!", preferredStyle: .alert)
        dialog.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] _ in
            guard let self else { return }
            self.viewModel.resetGame()
            self.fetchScores()
        }))
        dialog.addAction(UIAlertAction(title: "No", style: .cancel))
        self.present(dialog, animated: true)
    }
}
