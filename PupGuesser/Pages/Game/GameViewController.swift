//
//  GameViewController.swift
//  PupGuesser
//
//  Created by See Soon Kiat on 31/5/25.
//

import UIKit
import Combine
import OSLog

class GameViewController: UIViewController {
    private lazy var cardView = createCardView()
    private lazy var exitButton = createExitButton()
    private lazy var titleLabel = createTitleLabel()
    private lazy var currentStreakLabel = createStreakLabel()
    private lazy var currentScoreLabel = createScoreLabel()
    private var containerView: UIView?
    
    // Game Views
    private lazy var loadingView = GameLoadingView()
    private lazy var errorView = GameErrorView()
    private lazy var gameView = GameRoundView(delegate: self)
    
    private var viewModel: GameViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: GameViewModelProtocol = GameViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBinding()
        prepareNextRound()
        updateScores()
    }
    
    private func setupView() {
        view.backgroundColor = .basePrimary
        view.addSubview(cardView)
        view.addSubview(exitButton)
        
        // Title Stack
        let titleStackView = UIStackView(axis: .horizontal)
        let logoImage = UIImage(systemName: "pawprint.fill")
        let logo = UIImageView(image: logoImage)
        logo.tintColor = .systemOrange
        logo.transform = CGAffineTransform(rotationAngle: .pi * 1.85)
        titleStackView.addArrangedSubview(logo)
        titleStackView.addArrangedSubview(titleLabel)
        titleLabel.text = "Question 1"
        cardView.addSubview(titleStackView)
        
        logo.snp.makeConstraints { make in
            make.width.height.equalTo(48)
        }
        
        // Footer Stack
        let footerStackView = UIStackView(axis: .horizontal)
        footerStackView.addArrangedSubview(currentStreakLabel)
        footerStackView.addArrangedSubview(UIView()) // Spacer
        footerStackView.addArrangedSubview(currentScoreLabel)
        cardView.addSubview(footerStackView)
        
        // Container
        let containerView = UIView(frame: .zero)
        self.containerView = containerView
        cardView.addSubview(containerView)
        
        containerView.addSubview(loadingView)
        containerView.addSubview(errorView)
        containerView.addSubview(gameView)
        
        loadingView.isHidden = true
        errorView.isHidden = true
        gameView.isHidden = true
        
        // Constraints
        cardView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        titleStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().offset(8)
            make.trailing.lessThanOrEqualToSuperview().offset(-8)
        }
        footerStackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        containerView.snp.makeConstraints { make in
            make.top.equalTo(titleStackView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalTo(footerStackView.snp.top).offset(-8)
        }
        exitButton.snp.makeConstraints { make in
            make.top.leading.equalTo(cardView).inset(8)
        }
        loadingView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
        errorView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
        gameView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
    }
    
    private func setupBinding() {
        errorView.retryPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.prepareNextRound()
            }
            .store(in: &cancellables)
        gameView.nextPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.prepareNextRound()
            }
            .store(in: &cancellables)
    }
    
    private func prepareNextRound() {
        showLoadingView()
        viewModel.fetchNextRound()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    ErrorLogger.logError(error: error)
                    guard let self else { return }
                    self.showErrorView()
                }
            } receiveValue: { [weak self] gameRound in
                guard let self else { return }
                self.showGameView(gameRound)
            }
            .store(in: &cancellables)
    }
    
    private func showLoadingView() {
        loadingView.isHidden = false
        gameView.isHidden = true
        errorView.isHidden = true
    }
    
    private func showErrorView() {
        loadingView.isHidden = true
        gameView.isHidden = true
        errorView.isHidden = false
    }
    
    private func showGameView(_ gameRound: GameRound) {
        loadingView.isHidden = true
        gameView.isHidden = false
        errorView.isHidden = true
        gameView.startGame(gameRound)
        titleLabel.text = "Question \(viewModel.currentRound)"
    }
    
    private func updateScores() {
        currentScoreLabel.text = "Current Score: \(viewModel.score)"
        currentStreakLabel.text = "Current Streak: \(viewModel.streak)"
    }
    
    // MARK: - View Components
    
    private func createCardView() -> UIView {
        let card = UIView()
        card.backgroundColor = .accentPrimary
        card.layer.borderColor = UIColor.contentPrimary.cgColor
        card.layer.borderWidth = 0.5
        card.layer.cornerRadius = 16
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.1
        card.layer.shadowOffset = CGSize(width: 4, height: 4)
        card.layer.shadowRadius = 8
        return card
    }
    
    private func createExitButton() -> UIButton {
        let button = UIButton(type: .custom)
        if let crossImage = UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate) {
            button.setImage(crossImage, for: .normal)
            button.tintColor = .contentPrimary
        }
        button.setTitle("End", for: .normal)
        button.setTitleColor(.contentPrimary, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.addTarget(self, action: #selector(exitGameConfirmation), for: .touchUpInside)
        return button
    }
    
    @objc private func exitGameConfirmation() {
        let dialog = UIAlertController(title: "Are you sure?", message: "The game will end and scores will be recorded.", preferredStyle: .alert)
        dialog.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] _ in
            guard let self else { return }
            self.navigationController?.popToRootViewController(animated: true)
        }))
        dialog.addAction(UIAlertAction(title: "No", style: .cancel))
        self.present(dialog, animated: true)
    }
    
    private func createTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 36, weight: .heavy)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .contentPrimary
        return label
    }
    
    private func createStreakLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .contentPrimary
        return label
    }
    
    private func createScoreLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 1
        label.textAlignment = .right
        label.textColor = .contentPrimary
        return label
    }
}

extension GameViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.currentGameRound?.options.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionCell", for: indexPath)
        guard let optionCell = cell as? OptionCell,
              let option = viewModel.currentGameRound?.options[indexPath.row] else {
            return cell
        }
        optionCell.updateView(option: option.displayName)
        if let option = viewModel.selectedOption, let currentGameRound = viewModel.currentGameRound {
            optionCell.updateResult(selected: option.displayName, correct: currentGameRound.selectedBreed.displayName)
        }
        return optionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard viewModel.selectedOption == nil else {
            return
        }
        let result = viewModel.submitAnswer(index: indexPath.row)
        self.gameView.updateView(correct: result)
        self.updateScores()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns = 2
        let spacing = 12.0
        let totalSpacing = (CGFloat(columns) - 1) * spacing
        let width = (collectionView.bounds.width - totalSpacing) / CGFloat(columns)
        return CGSize(width: width, height: 50.0)
    }
}
