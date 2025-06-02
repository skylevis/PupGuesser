//
//  PuppediaViewModel.swift
//  PupGuesser
//
//  Created by See Soon Kiat on 3/6/25.
//

import Foundation
import Combine

protocol PuppediaViewModelProtocol {
    var breedList: [Breed]? { get }
    var discoveredList: [Breed] { get }
    var imageUrls: [String] { get }
    var cancellables: Set<AnyCancellable> { get set }
    
    func fetchPuppedia() -> [Breed]
    func fetchImageUrls(for breed: Breed) -> [String]
    func fetchBreedList() -> AnyPublisher<[Breed], Error>
}

class PuppediaViewModel: PuppediaViewModelProtocol, ObservableObject {
    private var networkService: NetworkServiceProtocol
    private var gameStorage: GameStorageProtocol
    
    @Published var breedList: [Breed]?
    @Published var discoveredList = [Breed]()
    @Published var imageUrls = [String]()
    @Published var selectedBreed: Breed?
    @Published var isLoading = false
    
    var cancellables = Set<AnyCancellable>()
    
    init(networkService: NetworkServiceProtocol = NetworkService(),
         gameStorage: GameStorageProtocol = GameStorage()) {
        self.networkService = networkService
        self.gameStorage = gameStorage
    }
    
    func fetchPuppedia() -> [Breed] {
        discoveredList = gameStorage.getAllDiscoveredBreeds().sorted { a, b in
            a.displayName.localizedCaseInsensitiveCompare(b.displayName) == .orderedAscending
        }
        return discoveredList
    }
    
    func fetchImageUrls(for breed: Breed) -> [String] {
        selectedBreed = breed
        imageUrls = gameStorage.getAllImageURLs(for: breed)
        return imageUrls
    }
    
    func fetchBreedList() -> AnyPublisher<[Breed], Error> {
        isLoading = true
        return networkService.getAllBreeds()
            .receive(on: RunLoop.main)
            .map { [weak self] totalList in
                guard let self else { return totalList }
                self.breedList = totalList
                self.isLoading = false
                return totalList
            }
            .eraseToAnyPublisher()
    }
}
