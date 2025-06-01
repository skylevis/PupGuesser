//
//  Breed.swift
//  PupGuesser
//
//  Created by See Soon Kiat on 31/5/25.
//

import Foundation

struct Breed: Codable, Equatable {
    let name: String
    let subBreed: String?
    
    var displayName: String {
        if let subBreed {
            return "\(subBreed) \(name)".capitalized
        } else {
            return name.capitalized
        }
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.displayName == rhs.displayName
    }
}
