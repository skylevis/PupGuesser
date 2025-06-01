//
//  PuppediaSpec.swift
//  PupGuesserTests
//
//  Created by See Soon Kiat on 1/6/25.
//

import Quick
import Nimble
import Combine
import Foundation
@testable import PupGuesser

final class PuppediaSpec: QuickSpec {
    
    override class func spec() {
        var puppediaVM: PuppediaViewModel!
        var mockNetworkService: MockNetworkService!
        var mockGameStorage: MockStorage!
        var cancellables = Set<AnyCancellable>()
        
        beforeEach {
            cancellables.forEach({ $0.cancel() })
            cancellables.removeAll()
            mockNetworkService = MockNetworkService(mockBreeds: mockBreeds, mockImageData: mockImageData.randomElement())
            mockGameStorage = MockStorage()
            puppediaVM = PuppediaViewModel(networkService: mockNetworkService,
                                           gameStorage: mockGameStorage)
        }
        
        describe("As a puppedia view model") {
            it("should fetch all available breeds correctly") {
                waitUntil(timeout: .seconds(3)) { done in
                    puppediaVM.fetchBreedList()
                        .sink { completion in
                            if case .failure(let error) = completion {
                                fail("Failed to fetch all breeds - \(error)")
                            }
                            done()
                        } receiveValue: { _ in
                            
                        }
                        .store(in: &cancellables)
                }
                expect(puppediaVM.breedList?.count).to(equal(mockBreeds.count))
            }
            
            it("should fetch all discovered entries correctly") {
                // Empty case
                var discoveredBreeds = puppediaVM.fetchPuppedia()
                expect(discoveredBreeds.count).to(equal(0))
                expect(puppediaVM.discoveredList.count).to(equal(0))
                
                // Save some mock data
                let randomEntries = Array(mockBreeds.shuffled().prefix(10))
                randomEntries.forEach { breed in
                    mockGameStorage.savePuppy(breed: breed, imageURL: "something")
                }
                discoveredBreeds = puppediaVM.fetchPuppedia()
                expect(discoveredBreeds.count).to(equal(10))
                expect(puppediaVM.discoveredList.count).to(equal(10))
            }
            
            it("should fetch all image urls for the given breed") {
                let randomBreed = mockBreeds.shuffled().first!
                var imageUrls = puppediaVM.fetchImageUrls(for: randomBreed)
                expect(imageUrls).to(beEmpty())
                
                // Save some images
                for i in Array(0..<4) {
                    mockGameStorage.savePuppy(breed: randomBreed, imageURL: "url-\(i)")
                }
                imageUrls = puppediaVM.fetchImageUrls(for: randomBreed)
                expect(imageUrls.count).to(equal(4))
            }
        }
    }
}
