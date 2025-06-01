//
//  PupGuesserTests.swift
//  PupGuesserTests
//
//  Created by See Soon Kiat on 31/5/25.
//

import Quick
import Nimble
import Combine
import Foundation
@testable import PupGuesser

final class GameSpec: QuickSpec {
    
    override class func spec() {
        var gameVM: GameViewModel!
        var mockNetworkService: MockNetworkService!
        var mockGameStorage: MockStorage!
        var cancellables = Set<AnyCancellable>()
        
        describe("As a Game view model") {
            beforeEach {
                cancellables.forEach({ $0.cancel() })
                cancellables.removeAll()
                mockNetworkService = MockNetworkService(mockBreeds: mockBreeds, mockImageData: mockImageData.randomElement())
                mockGameStorage = MockStorage()
                gameVM = GameViewModel(networkService: mockNetworkService,
                                       gameStorage: mockGameStorage)
            }
            
            it("should be able to fetch the next round correctly") {
                var gameRound: GameRound!
                waitUntil(timeout: .seconds(3)) { done in
                    gameVM.fetchNextRound()
                        .sink { completion in
                            if case .failure(let error) = completion {
                                fail("Failed to fetch next round - \(error)")
                            }
                            done()
                        } receiveValue: { result in
                            gameRound = result
                        }
                        .store(in: &cancellables)
                }
                guard let gameRound else {
                    return
                }
                expect(gameRound.options.count).to(equal(4))
                expect(gameRound.imageData).toNot(beNil())
                expect(gameRound.selectedBreed).toNot(beNil())
                expect(gameRound.options).to(contain(gameRound.selectedBreed))
            }
            
            it("should handle failed to fetch error correctly") {
                // Simulate error
                mockNetworkService.mockError = MockError.mockError
                waitUntil(timeout: .seconds(3)) { done in
                    gameVM.fetchNextRound()
                        .sink { completion in
                            if case .failure(let error) = completion {
                                expect(error).to(matchError(MockError.mockError))
                            } else {
                                fail("Should throw error!")
                            }
                            done()
                        } receiveValue: { _ in
                            
                        }
                        .store(in: &cancellables)
                }
                expect(gameVM.currentGameRound).to(beNil())
            }
            
            it("should update the game state correctly when submitting an answer") {
                let randomOptions = Array(mockBreeds.shuffled().prefix(4))
                let answer = randomOptions.last!
                gameVM.currentGameRound = GameRound(imageData: ImageData(url: "something", data: Data()),
                                                    selectedBreed: answer, options: randomOptions)
                var result = gameVM.submitAnswer(index: randomOptions.count - 1)
                expect(result).to(beTrue())
                expect(gameVM.score).to(equal(1))
                expect(gameVM.streak).to(equal(1))
                
                gameVM.selectedOption = nil // reset option
                result = gameVM.submitAnswer(index: 0)
                expect(result).to(beFalse())
                expect(gameVM.score).to(equal(1))
                expect(gameVM.streak).to(equal(0))
            }
            
            it("should update the scores correctly") {
                var hiscore = mockGameStorage.getHiScore()
                expect(hiscore.score).to(equal(0))
                expect(hiscore.streak).to(equal(0))
                
                gameVM.score = 4
                gameVM.streak = 2
                gameVM.saveScores()
                hiscore = mockGameStorage.getHiScore()
                expect(hiscore.score).to(equal(4))
                expect(hiscore.streak).to(equal(2))
            }
        }
    }
}
