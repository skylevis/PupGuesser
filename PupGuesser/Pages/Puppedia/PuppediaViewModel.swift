//
//  PuppediaViewModel.swift
//  PupGuesser
//
//  Created by See Soon Kiat on 1/6/25.
//

import Foundation
import Combine

protocol PuppediaViewModelProtocol {
    var breedList: [Breed]? { get }
    var discoveredList: [Breed] { get }
    var imageUrls: [String] { get }
    
    func fetchPuppedia() -> [Breed]
    func fetchImageUrls(for breed: Breed) -> [String]
    func fetchBreedList() -> AnyPublisher<[Breed], Error>
}

class PuppediaViewModel: PuppediaViewModelProtocol {
    private var networkService: NetworkServiceProtocol
    private var gameStorage: GameStorageProtocol
    
    var breedList : [Breed]?
    var discoveredList = [Breed]()
    var imageUrls = [String]()
    
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
        imageUrls = gameStorage.getAllImageURLs(for: breed)
        return imageUrls
    }
    
    func fetchBreedList() -> AnyPublisher<[Breed], Error> {
        return networkService.getAllBreeds()
            .map { [weak self] totalList in
                guard let self else { return totalList }
                self.breedList = totalList
                return totalList
            }
            .eraseToAnyPublisher()
    }
}
