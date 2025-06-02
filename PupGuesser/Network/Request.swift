//
//  Request.swift
//  PupGuesser
//
//  Created by See Soon Kiat on 3/6/25.
//

import Foundation

enum Request {
    case allBreeds
    case allSubBreeds(breed: String)
    
    case allImages(breed: Breed)
    
    case randomImageAny
    case randomImage(breed: Breed)
    
    func getRequestURL() -> URL? {
        switch self {
            // Breeds
        case .allBreeds:
            return URL(string: Constants.baseURLString + "/breeds/list/all")
        case .allSubBreeds(let breed):
            return URL(string: Constants.baseURLString + "/breed/\(breed)/list")
            
            // All Images
        case .allImages(let breed):
            if let subBreed = breed.subBreed {
                return URL(string: Constants.baseURLString + "/breed/\(breed.name)/\(subBreed)/images")
            } else {
                return URL(string: Constants.baseURLString + "/breed/\(breed.name)/images")
            }
            
            // Random Image
        case .randomImageAny:
            return URL(string: Constants.baseURLString + "/breeds/image/random")
        case .randomImage(let breed):
            if let subBreed = breed.subBreed {
                return URL(string: Constants.baseURLString + "/breed/\(breed.name)/\(subBreed)/images/random")
            } else {
                return URL(string: Constants.baseURLString + "/breed/\(breed.name)/images/random")
            }
        }
    }
}
