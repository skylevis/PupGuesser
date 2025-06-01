//
//  PuppediaViewController.swift
//  PupGuesser
//
//  Created by See Soon Kiat on 1/6/25.
//

import Foundation
import UIKit
import Combine

class PuppediaViewController: UIViewController {
    private lazy var puppyTableView = createTableView()
    private lazy var puppyImageCollectionView = createCollectionView()
    private var viewModel: PuppediaViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: PuppediaViewModelProtocol = PuppediaViewModel()) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        setupView()
        fetchData()
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func setupView() {
        title = "Puppedia"
        let stackView = UIStackView(axis: .horizontal, spacing: 12)
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.addArrangedSubview(puppyTableView)
        stackView.addArrangedSubview(puppyImageCollectionView)
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(12)
        }
        puppyTableView.snp.makeConstraints { make in
            make.width.equalTo(stackView).multipliedBy(0.35)
        }
    }
    
    private func fetchData() {
        _ = viewModel.fetchPuppedia()
        puppyTableView.reloadData()
        
        // Setup table header for total count
        viewModel.fetchBreedList()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    ErrorLogger.logError(error: error, category: "Puppedia")
                }
            } receiveValue: { [weak self] _ in
                guard let self else { return }
                self.puppyTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func createTableView() -> UITableView {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .accentPrimary
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BreedTableViewCell.self, forCellReuseIdentifier: "BreedTableViewCell")
        tableView.separatorColor = .contentSecondary
        tableView.separatorStyle = .singleLine
        return tableView
    }
    
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BreedImageCollectionViewCell.self, forCellWithReuseIdentifier: "BreedImageCollectionViewCell")
        return collectionView
    }
}

extension PuppediaViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.discoveredList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BreedTableViewCell", for: indexPath)
        guard let breedCell = cell as? BreedTableViewCell else {
            return cell
        }
        breedCell.updateCell(breedName: viewModel.discoveredList[indexPath.row].displayName)
        return breedCell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let totalBreeds = viewModel.breedList else {
            return nil
        }
        let headerView = BreedTableHeaderView(tableView: tableView)
        headerView.setCount(discovered: viewModel.discoveredList.count, total: totalBreeds.count)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let totalBreeds = viewModel.breedList else {
            return 0
        }
        return BreedTableHeaderView.viewHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = viewModel.fetchImageUrls(for: viewModel.discoveredList[indexPath.row])
        puppyImageCollectionView.reloadData()
    }
}

extension PuppediaViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BreedImageCollectionViewCell", for: indexPath)
        guard let breedImageCell = cell as? BreedImageCollectionViewCell else {
            return cell
        }
        breedImageCell.setImage(url: viewModel.imageUrls[indexPath.row])
        return breedImageCell
    }
}

private class BreedTableHeaderView: UIView {
    private lazy var countLabel = createCountLabel()
    static let viewHeight = 40.0
    
    init(tableView: UITableView) {
        super.init(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: Self.viewHeight))
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .baseSecondary
        layer.cornerRadius = 12
        clipsToBounds = true
        
        addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview().inset(8)
        }
    }
    
    func setCount(discovered: Int, total: Int) {
        countLabel.text = "Discovered: \(discovered) / \(total)"
    }
    
    private func createCountLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .contentInverse
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textAlignment = .left
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }
}
