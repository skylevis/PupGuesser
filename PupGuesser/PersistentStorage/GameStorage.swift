//
//  GameStorage.swift
//  PupGuesser
//
//  Created by See Soon Kiat on 1/6/25.
//

import Foundation

protocol GameStorageProtocol {
    func savePuppy(breed: Breed, imageURL: String)
    func getAllDiscoveredBreeds() -> [Breed]
    func getAllImageURLs(for breed: Breed) -> [String]
    func saveHiScore(_ score: Int, streak: Int)
    func getHiScore() -> (score: Int, streak: Int)
    func resetStorage()
}

class GameStorage: GameStorageProtocol {
    private let bundleSuite = "\(Bundle.main.bundleIdentifier ?? "game").storage"
    private let puppediaKey = "puppedia"
    private let hiscoreKey = "hiscore"
    
    func savePuppy(breed: Breed, imageURL: String) {
        var puppedia = getPuppedia()
        if let currentEntry = puppedia[breed.displayName] {
            guard !currentEntry.imageUrls.contains(imageURL) else {
                return
            }
            let newEntry = PuppediaEntry(breed: breed, imageUrls: currentEntry.imageUrls + [imageURL])
            puppedia[breed.displayName] = newEntry
        } else {
            let newEntry = PuppediaEntry(breed: breed, imageUrls: [imageURL])
            puppedia[breed.displayName] = newEntry
        }
        savePuppedia(puppedia)
    }
    
    func getAllDiscoveredBreeds() -> [Breed] {
        let puppedia = getPuppedia()
        let allKeys = puppedia.keys
        return allKeys.compactMap { key in
            guard let entry = puppedia[key] else {
                return nil
            }
            return entry.breed
        }
    }
    
    func getAllImageURLs(for breed: Breed) -> [String] {
        let puppedia = getPuppedia()
        guard let entry = puppedia[breed.displayName] else {
            return []
        }
        return entry.imageUrls
    }
    
    func saveHiScore(_ score: Int, streak: Int) {
        let currentHiscore = getHiscore() ?? HiScores(score: 0, streak: 0)
        let newHiscore = HiScores(score: max(currentHiscore.score, score),
                                  streak: max(currentHiscore.streak, streak))
        saveHiscore(newHiscore)
    }
    
    func getHiScore() -> (score: Int, streak: Int) {
        let currentHiscore = getHiscore() ?? HiScores(score: 0, streak: 0)
        return (currentHiscore.score, currentHiscore.streak)
    }
    
    func resetStorage() {
        guard let localStorage = UserDefaults(suiteName: bundleSuite) else {
            ErrorLogger.logError(error: StorageError.failedToInitStorage, category: "GameStorage")
            return
        }
        localStorage.removeObject(forKey: puppediaKey)
        localStorage.removeObject(forKey: hiscoreKey)
    }
    
    private func getPuppedia() -> [String: PuppediaEntry] {
        guard let localStorage = UserDefaults(suiteName: bundleSuite),
              let puppedia = localStorage.dictionary(forKey: puppediaKey) as? [String: PuppediaEntry] else {
            ErrorLogger.logError(error: StorageError.failedToInitStorage, category: "GameStorage")
            return [:]
        }
        return puppedia
    }
    
    private func savePuppedia(_ puppedia: [String: PuppediaEntry]) {
        guard let localStorage = UserDefaults(suiteName: bundleSuite) else {
            ErrorLogger.logError(error: StorageError.failedToInitStorage, category: "GameStorage")
            return
        }
        localStorage.set(puppedia, forKey: puppediaKey)
    }
    
    private func getHiscore() -> HiScores? {
        guard let localStorage = UserDefaults(suiteName: bundleSuite),
              let hiscores = localStorage.object(forKey: hiscoreKey) as? HiScores else {
            return nil
        }
        return hiscores
    }
    
    private func saveHiscore(_ hiscore: HiScores) {
        guard let localStorage = UserDefaults(suiteName: bundleSuite) else {
            ErrorLogger.logError(error: StorageError.failedToInitStorage, category: "GameStorage")
            return
        }
        localStorage.set(hiscore, forKey: hiscoreKey)
    }
}

struct PuppediaEntry: Codable {
    let breed: Breed
    let imageUrls: [String]
}

struct HiScores: Codable {
    let score: Int
    let streak: Int
}

enum StorageError: Error {
    case failedToInitStorage
}
