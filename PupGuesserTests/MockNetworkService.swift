//
//  MockNetworkService.swift
//  PupGuesserTests
//
//  Created by See Soon Kiat on 1/6/25.
//

import Foundation
import Combine
@testable import PupGuesser

class MockNetworkService: NetworkServiceProtocol {
    var mockBreeds: [Breed]
    var mockImageData: ImageData?
    var mockError: Error?
    
    init(mockBreeds: [Breed] = [],
         mockImageData: ImageData? = nil) {
        self.mockBreeds = mockBreeds
        self.mockImageData = mockImageData
    }
    
    func getAllBreeds() -> AnyPublisher<[PupGuesser.Breed], any Error> {
        if let mockError {
            return Fail(error: mockError)
                .eraseToAnyPublisher()
        }
        return Just(mockBreeds)
            .delay(for: 0.1, scheduler: DispatchQueue.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func getRandomImage(breed: PupGuesser.Breed) -> AnyPublisher<PupGuesser.ImageData, any Error> {
        guard let mockImageData else {
            return Fail(error: MockError.mockError)
                .eraseToAnyPublisher()
        }
        return Just(mockImageData)
            .delay(for: 0.1, scheduler: DispatchQueue.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

enum MockError: Error {
    case mockError
}
