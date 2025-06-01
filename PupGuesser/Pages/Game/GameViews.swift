//
//  GameViews.swift
//  PupGuesser
//
//  Created by See Soon Kiat on 1/6/25.
//

import UIKit
import Combine

class GameRoundView: UIView {
    private lazy var puppyImage = createPuppyImageView()
    private lazy var questionLabel = createQuestionLabel()
    private lazy var correctResult = createCorrectResultView()
    private lazy var wrongResult = createWrongResultView()
    private lazy var confirmButton = createConfirmButton()
    private lazy var optionCollectionView = createOptionCollectionView()
    
    private let nextSubject = PassthroughSubject<Void, Never>()
    var nextPublisher: AnyPublisher<Void, Never> {
        nextSubject.eraseToAnyPublisher()
    }
    
    init(delegate: UICollectionViewDelegateFlowLayout & UICollectionViewDataSource) {
        super.init(frame: .zero)
        setupView()
        optionCollectionView.delegate = delegate
        optionCollectionView.dataSource = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(puppyImage)
        addSubview(questionLabel)
        addSubview(optionCollectionView)
        
        // Result stack
        let resultStackView = UIStackView(axis: .horizontal)
        let leftSpacer = UIView()
        let rightSpacer = UIView()
        resultStackView.addArrangedSubview(leftSpacer)
        resultStackView.addArrangedSubview(correctResult)
        resultStackView.addArrangedSubview(wrongResult)
        resultStackView.addArrangedSubview(rightSpacer)
        addSubview(resultStackView)
        
        addSubview(confirmButton)
        
        puppyImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(240)
        }
        questionLabel.snp.makeConstraints { make in
            make.top.equalTo(puppyImage.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        optionCollectionView.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(OptionCell.optionHeight * 2 + 12.0)
        }
        resultStackView.snp.makeConstraints { make in
            make.top.equalTo(optionCollectionView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        leftSpacer.snp.makeConstraints { make in
            make.width.equalTo(rightSpacer)
        }
        confirmButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(16)
            make.top.greaterThanOrEqualTo(resultStackView.snp.bottom).offset(16)
        }
        
        resetView()
    }
    
    func resetView() {
        correctResult.isHidden = true
        wrongResult.isHidden = true
        confirmButton.isHidden = true
    }
    
    func startGame(_ gameRound: GameRound) {
        resetView()
        let image = UIImage(data: gameRound.imageData.data)
        puppyImage.image = image
        optionCollectionView.reloadData()
    }
    
    func updateView(correct: Bool) {
        if correct {
            correctResult.isHidden = false
            wrongResult.isHidden = true
        } else {
            correctResult.isHidden = true
            wrongResult.isHidden = false
        }
        confirmButton.isHidden = false
        optionCollectionView.reloadData()
    }
    
    private func createPuppyImageView() -> UIImageView {
        let imageFrame = UIImageView(frame: .zero)
        imageFrame.layer.cornerRadius = 20
        imageFrame.clipsToBounds = true
        return imageFrame
    }
    
    private func createQuestionLabel() -> UILabel {
        let questionLabel = UILabel()
        questionLabel.text = "Which breed is this?"
        questionLabel.textColor = .contentPrimary
        questionLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        questionLabel.textAlignment = .center
        return questionLabel
    }
    
    private func createCorrectResultView() -> UIView {
        let stack = UIStackView(axis: .vertical, spacing: 8)
        let correctIcon = UIImage(systemName: "checkmark.circle.fill")
        let correctImage = UIImageView(image: correctIcon)
        correctImage.contentMode = .scaleAspectFit
        correctImage.tintColor = .systemGreen
        let label = UILabel()
        label.text = "Correct!"
        label.textColor = .systemGreen
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 1
        stack.addArrangedSubview(correctImage)
        stack.addArrangedSubview(label)
        stack.addArrangedSubview(UIView())
        
        correctImage.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        return stack
    }
    
    private func createWrongResultView() -> UIView {
        let stack = UIStackView(axis: .vertical, spacing: 8)
        let wrongIcon = UIImage(systemName: "xmark.circle.fill")
        let wrongImage = UIImageView(image: wrongIcon)
        wrongImage.contentMode = .scaleAspectFit
        wrongImage.tintColor = .systemRed
        let label = UILabel()
        label.text = "Oops! Try again!"
        label.textColor = .systemRed
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 1
        stack.addArrangedSubview(wrongImage)
        stack.addArrangedSubview(label)
        stack.addArrangedSubview(UIView())
        
        wrongImage.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        return stack
    }
    
    private func createConfirmButton() -> UIButton {
        let button = UIButton.primaryButton(title: "Next", image: nil)
        button.configuration?.buttonSize = .medium
        button.addTarget(self, action: #selector(onConfirm), for: .touchUpInside)
        return button
    }
    
    @objc private func onConfirm() {
        nextSubject.send(())
    }
    
    private func createOptionCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(OptionCell.self, forCellWithReuseIdentifier: "OptionCell")
        return collectionView
    }
}

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

class GameLoadingView: UIView {
    private lazy var loadingLabel = createLoadingLabel()
    private lazy var loader = createLoader()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(loadingLabel)
        addSubview(loader)
        loader.startAnimating()
        
        loader.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        loadingLabel.snp.makeConstraints { make in
            make.top.equalTo(loader.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }
    
    func showLoading(_ show: Bool = true) {
        self.isHidden = !show
    }
    
    private func createLoadingLabel() -> UILabel {
        let loadingLabel = UILabel()
        loadingLabel.text = "Fetching your next pup..."
        loadingLabel.textColor = .contentPrimary
        loadingLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        loadingLabel.numberOfLines = 0
        loadingLabel.textAlignment = .center
        return loadingLabel
    }
    
    private func createLoader() -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: .large)
    }
}

class GameErrorView: UIView {
    private lazy var errorImage = createErrorImage()
    private lazy var label = createLabel()
    private lazy var retryButton = createRetryButton()
    
    private let retrySubject = PassthroughSubject<Void, Never>()
    var retryPublisher: AnyPublisher<Void, Never> {
        return retrySubject.eraseToAnyPublisher()
    }
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(errorImage)
        addSubview(label)
        addSubview(retryButton)
        
        errorImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(200)
            make.bottom.equalTo(label.snp.top).offset(-16)
        }
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
        }
        retryButton.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
    }
    
    private func createErrorImage() -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: "SadDog"))
        return imageView
    }
    
    private func createLabel() -> UILabel {
        let loadingLabel = UILabel()
        loadingLabel.text = "Oops! Something went wrong!"
        loadingLabel.textColor = .contentPrimary
        loadingLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        loadingLabel.numberOfLines = 0
        loadingLabel.textAlignment = .center
        return loadingLabel
    }
    
    private func createRetryButton() -> UIButton {
        let button = UIButton.outlinedButton(title: "Retry", image: nil)
        button.addTarget(self, action: #selector(onTap), for: .touchUpInside)
        return button
    }
    
    @objc private func onTap() {
        retrySubject.send(())
    }
}
