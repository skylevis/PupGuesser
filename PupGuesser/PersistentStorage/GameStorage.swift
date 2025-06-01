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
    func getHiScore() -> HiScores
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
    
    func getHiScore() -> HiScores {
        let currentHiscore = getHiscore() ?? HiScores(score: 0, streak: 0)
        return currentHiscore
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
        guard let localStorage = UserDefaults(suiteName: bundleSuite) else {
            ErrorLogger.logError(error: StorageError.failedToInitStorage, category: "GameStorage")
            return [:]
        }
        guard let puppediaData = localStorage.data(forKey: puppediaKey) else {
            return [:]
        }
        do {
            let puppedia = try JSONDecoder().decode([String: PuppediaEntry].self, from: puppediaData)
            return puppedia
        } catch {
            ErrorLogger.logError(error: error, category: "GameStorage")
            return [:]
        }
    }
    
    private func savePuppedia(_ puppedia: [String: PuppediaEntry]) {
        guard let localStorage = UserDefaults(suiteName: bundleSuite) else {
            ErrorLogger.logError(error: StorageError.failedToInitStorage, category: "GameStorage")
            return
        }
        do {
            let json = try JSONEncoder().encode(puppedia)
            localStorage.set(json, forKey: puppediaKey)
        } catch {
            ErrorLogger.logError(error: error, category: "GameStorage")
        }
    }
    
    private func getHiscore() -> HiScores? {
        guard let localStorage = UserDefaults(suiteName: bundleSuite),
              let hiscoresData = localStorage.data(forKey: hiscoreKey) else {
            return nil
        }
        do {
            let hiscores = try JSONDecoder().decode(HiScores.self, from: hiscoresData)
            return hiscores
        } catch {
            ErrorLogger.logError(error: error, category: "GameStorage")
            return nil
        }
    }
    
    private func saveHiscore(_ hiscore: HiScores) {
        guard let localStorage = UserDefaults(suiteName: bundleSuite) else {
            ErrorLogger.logError(error: StorageError.failedToInitStorage, category: "GameStorage")
            return
        }
        do {
            let json = try JSONEncoder().encode(hiscore)
            localStorage.set(json, forKey: hiscoreKey)
        } catch {
            ErrorLogger.logError(error: error, category: "GameStorage")
        }
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
