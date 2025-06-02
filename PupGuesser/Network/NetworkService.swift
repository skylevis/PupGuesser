//
//  NetworkService.swift
//  PupGuesser
//
//  Created by See Soon Kiat on 3/6/25.
//

import Foundation
import Combine

protocol NetworkServiceProtocol {
    func getAllBreeds() -> AnyPublisher<[Breed], Error>
    func getRandomImage(breed: Breed) -> AnyPublisher<ImageData, Error>
}

class NetworkService: NetworkServiceProtocol {
    private(set) var session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func getAllBreeds() -> AnyPublisher<[Breed], Error> {
        guard let url = Request.allBreeds.getRequestURL() else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        return fetch(type: BreedResponseModel.self, from: url)
            .map { response in
                response.message.compactMap { (breed: String, subBreeds: [String]) -> [Breed] in
                    if subBreeds.isEmpty {
                        return [Breed(name: breed, subBreed: nil)]
                    } else {
                        return subBreeds.map { subBreed in
                            Breed(name: breed, subBreed: subBreed)
                        }
                    }
                }
                .reduce([]) { partialResult, next in
                    partialResult + next
                }
            }
            .eraseToAnyPublisher()
    }
    
    func getRandomImage(breed: Breed) -> AnyPublisher<ImageData, Error> {
        guard let url = Request.randomImage(breed: breed).getRequestURL() else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        return fetch(type: ImageResponseModel.self, from: url)
            .tryMap { response in
                guard let imageURL = URL(string: response.message) else {
                    throw NetworkError.invalidImageURL
                }
                return imageURL
            }
            .flatMap(loadImage)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    private func loadImage(from url: URL) -> AnyPublisher<ImageData, Error> {
        return Future { [weak self] promise in
            guard let self else { return }
            Task {
                do {
                    let (data, _) = try await self.session.data(from: url)
                    let imageData = ImageData(url: url.absoluteString, data: data)
                    await MainActor.run {
                        promise(.success(imageData))
                    }
                } catch {
                    promise(.failure(NetworkError.unexpected(message: "Failed to load image for \(url.absoluteString)")))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func fetch<T: Decodable>(type: T.Type, from url: URL) -> AnyPublisher<T, Error> {
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

enum NetworkError: Error {
    case invalidURL
    case invalidImageURL
    case unexpected(message: String)
}

private struct BreedResponseModel: Codable {
    let message: [String: [String]]
    let status: String
}

private struct ImageResponseModel: Codable {
    let message: String
    let status: String
}
