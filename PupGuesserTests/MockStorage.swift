//
//  MockStorage.swift
//  PupGuesserTests
//
//  Created by See Soon Kiat on 1/6/25.
//

import Foundation
import Combine
@testable import PupGuesser

class MockStorage: GameStorageProtocol {
    var puppedia: [String: PuppediaEntry]
    var hiscores: HiScores
    
    init(puppedia: [String : PuppediaEntry] = [:],
         hiscores: HiScores = HiScores(score: 0, streak: 0)) {
        self.puppedia = puppedia
        self.hiscores = hiscores
    }
    
    func savePuppy(breed: PupGuesser.Breed, imageURL: String) {
        let entry = puppedia[breed.displayName] ?? PuppediaEntry(breed: breed, imageUrls: [])
        let updatedImageUrls = Set(entry.imageUrls + [imageURL])
        puppedia[breed.displayName] = PuppediaEntry(breed: breed, imageUrls: Array(updatedImageUrls))
    }
    
    func getAllDiscoveredBreeds() -> [PupGuesser.Breed] {
        return puppedia.keys.compactMap { key in
            return puppedia[key]?.breed
        }
    }
    
    func getAllImageURLs(for breed: PupGuesser.Breed) -> [String] {
        guard let entry = puppedia[breed.displayName] else {
            return []
        }
        return entry.imageUrls
    }
    
    func saveHiScore(_ score: Int, streak: Int) {
        hiscores = HiScores(score: score,
                            streak: streak)
    }
    
    func getHiScore() -> PupGuesser.HiScores {
        return hiscores
    }
    
    func resetStorage() {
        hiscores = HiScores(score: 0, streak: 0)
        puppedia = [:]
    }
}
