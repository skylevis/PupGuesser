//
//  GameViewModel.swift
//  PupGuesser
//
//  Created by See Soon Kiat on 31/5/25.
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
}

class GameViewModel: GameViewModelProtocol {
    private var breedsList: [Breed] = [] // Cached
    private var networkService: NetworkServiceProtocol
    
    // Game Configuration
    private let numOptions = 4
    
    // Game State
    var currentGameRound: GameRound?
    var currentRound = 0
    var streak = 0
    var score = 0
    var selectedOption: Breed?
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchNextRound() -> AnyPublisher<GameRound, Error> {
        selectedOption = nil
        return fetchBreedList()
            .flatMap(setupGameRound)
            .map { [weak self] gameRound in
                guard let self else {
                    return gameRound
                }
                self.currentGameRound = gameRound
                self.currentRound += 1 
                return gameRound
            }
            .eraseToAnyPublisher()
    }
    
    func submitAnswer(index: Int) -> Bool {
        guard let currentGameRound, selectedOption == nil else {
            return false
        }
        let answer = currentGameRound.options[index]
        selectedOption = answer
        let isCorrect = answer == currentGameRound.selectedBreed
        if isCorrect {
            score += 1
            streak += 1
        } else {
            streak = 0
        }
        return isCorrect
    }
    
    private func fetchBreedList() -> AnyPublisher<[Breed], Error> {
        guard !self.breedsList.isEmpty else {
            return networkService.getAllBreeds()
        }
        return Just(self.breedsList).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    private func fetchRandomImage(for breed: Breed) -> AnyPublisher<Data, Error> {
        return networkService.getRandomImage(breed: breed)
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
}

struct GameRound {
    let imageData: Data
    let selectedBreed: Breed
    let options: [Breed]
}

enum GameError: Error {
    case unexpected(message: String)
}
