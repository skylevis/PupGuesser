//
//  HiscoreViewModel.swift
//  PupGuesser
//
//  Created by See Soon Kiat on 3/6/25.
//

import Foundation

protocol HiscoreViewModelProtocol {
    func resetGame()
    func fetchScores() -> HiScores
}

class HiscoreViewModel: HiscoreViewModelProtocol, ObservableObject {
    private var gameStorage: GameStorageProtocol
    
    init(gameStorage: GameStorageProtocol = GameStorage()) {
        self.gameStorage = gameStorage
    }
    
    func resetGame() {
        gameStorage.resetStorage()
    }
    
    func fetchScores() -> HiScores {
        return gameStorage.getHiScore()
    }
}
