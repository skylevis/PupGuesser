//
//  Breed.swift
//  PupGuesser
//
//  Created by See Soon Kiat on 3/6/25.
//

import Foundation

struct Breed: Codable, Equatable, Identifiable, Hashable {
    let name: String
    let subBreed: String?
    
    // SwiftUI requires Identifiable
    var id: String {
        return displayName
    }
    
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
    
    // Hashable conformance for SwiftUI
    func hash(into hasher: inout Hasher) {
        hasher.combine(displayName)
    }
}
