//
//  GameViewModel.swift
//  PupGuesser
//
//  Created by See Soon Kiat on 3/6/25.
//

import Foundation
import Combine

protocol GameViewModelProtocol {
    var currentRound: Int { get }
    var streak: Int { get }
    var score: Int { get }
    var selectedOption: Breed? { get }
    var currentGameRound: GameRound? { get }
    
    func fetchNextRound() -> AnyPublisher<GameRound, Error>
    func submitAnswer(index: Int) -> Bool
    func saveScores()
}

class GameViewModel: ObservableObject, GameViewModelProtocol {
    @Published var gameState: GameState = .loading
    @Published var currentGameRound: GameRound?
    @Published var currentRound = 0
    @Published var streak = 0
    @Published var score = 0
    @Published var selectedOption: Breed?
    
    // Game Configuration
    private let numOptions = 4
    
    private var breedsList: [Breed] = [] // Cached
    private var cancellables = Set<AnyCancellable>()
    private var networkService: NetworkServiceProtocol
    private var gameStorage: GameStorageProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService(),
         gameStorage: GameStorageProtocol = GameStorage()) {
        self.networkService = networkService
        self.gameStorage = gameStorage
    }
    
    func loadNextRound() {
        gameState = .loading
        
        fetchNextRound()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure = completion {
                        self?.gameState = .error
                    }
                },
                receiveValue: { [weak self] gameRound in
                    guard let self = self else { return }
                    self.currentGameRound = gameRound
                    self.gameState = .playing
                }
            )
            .store(in: &cancellables)
    }
    
    func fetchNextRound() -> AnyPublisher<GameRound, Error> {
        gameState = .loading
        selectedOption = nil
        
        return fetchBreedList()
            .flatMap(setupGameRound)
            .map { [weak self] gameRound in
                guard let self = self else { return gameRound }
                self.gameStorage.savePuppy(breed: gameRound.selectedBreed, imageURL: gameRound.imageData.url)
                self.currentRound += 1
                return gameRound
            }
            .eraseToAnyPublisher()
    }
    
    func submitAnswer(index: Int) -> Bool {
        guard let currentGameRound, selectedOption == nil else { return false }
        
        let answer = currentGameRound.options[index]
        let isCorrect = answer == currentGameRound.selectedBreed
        selectedOption = answer
        
        if isCorrect {
            score += 1
            streak += 1
        } else {
            streak = 0
        }
        
        saveScores()
        return isCorrect
    }
    
    func saveScores() {
        gameStorage.saveHiScore(score, streak: streak)
    }
    
    private func fetchBreedList() -> AnyPublisher<[Breed], Error> {
        guard !self.breedsList.isEmpty else {
            return networkService.getAllBreeds()
        }
        return Just(self.breedsList).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    private func setupGameRound(_ breeds: [Breed]) -> AnyPublisher<GameRound, Error> {
        guard breeds.count > numOptions else {
            return Fail(error: GameError.unexpected(message: "Total breeds count: \(breeds.count) is less than available options: \(numOptions)")).eraseToAnyPublisher()
        }
        let options = Array(breeds.shuffled().prefix(numOptions))
        guard let selectedOption = options.randomElement() else {
            return Fail(error: GameError.unexpected(message: "Failed to select random breed")).eraseToAnyPublisher()
        }
        return fetchRandomImage(for: selectedOption)
            .map { imageData in
                GameRound(imageData: imageData, selectedBreed: selectedOption, options: options)
            }
            .eraseToAnyPublisher()
    }
    
    private func fetchRandomImage(for breed: Breed) -> AnyPublisher<ImageData, Error> {
        return networkService.getRandomImage(breed: breed)
    }
}

enum GameState {
    case loading
    case playing
    case error
}

struct GameRound {
    let imageData: ImageData
    let selectedBreed: Breed
    let options: [Breed]
}

enum GameError: Error {
    case unexpected(message: String)
}
