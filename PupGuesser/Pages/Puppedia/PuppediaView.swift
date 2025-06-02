//
//  PuppediaView.swift
//  PupGuesser
//
//  Created by See Soon Kiat on 3/6/25.
//

import SwiftUI

struct PuppediaView: View {
    @StateObject private var viewModel: PuppediaViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(viewModel: PuppediaViewModel = PuppediaViewModel()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 4) {
                // Left side - Breed List (exactly 35% width)
                BreedListView(viewModel: viewModel)
                    .frame(width: geometry.size.width * 0.35)
                
                // Right side - Image Grid (remaining width)
                ImageGridView(viewModel: viewModel)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .padding(.horizontal, 12)
        .background(Color.basePrimary)
        .ignoresSafeArea(.container, edges: .bottom) // Allow parent to extend
        .appNavigationBar(title: "My Puppedia") {
            dismiss()
        }
        .onAppear {
            loadData()
        }
    }
    
    private func loadData() {
        // First fetch the discovered breeds from local storage
        _ = viewModel.fetchPuppedia()
        
        // Then fetch the complete breed list from network
        viewModel.fetchBreedList()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        // Handle error - you can add error state to viewModel
                        print("Error loading breeds: \(error)")
                    }
                },
                receiveValue: { _ in
                    // Data loaded successfully - this will trigger UI update
                    // due to @Published breedList property
                }
            )
            .store(in: &viewModel.cancellables)
    }
}

// MARK: - Previews
import Combine

struct PuppediaView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Main PuppediaView with mock data
            NavigationView {
                PuppediaView(viewModel: PuppediaViewModel(
                    networkService: MockNetworkService(),
                    gameStorage: MockGameStorage()
                ))
            }
            .previewDisplayName("PuppediaView - With Data")
        }
    }
    
    private class MockNetworkService: NetworkServiceProtocol {
        func getAllBreeds() -> AnyPublisher<[Breed], any Error> {
            let mockBreeds = [
                Breed(name: "husky", subBreed: nil),
                Breed(name: "keeshond", subBreed: nil),
                Breed(name: "kelpie", subBreed: nil),
                Breed(name: "kombai", subBreed: nil),
                Breed(name: "komondor", subBreed: nil),
                Breed(name: "kuvasz", subBreed: nil),
                Breed(name: "labradoodle", subBreed: nil),
                Breed(name: "labrador", subBreed: nil),
                Breed(name: "leonberg", subBreed: nil),
                Breed(name: "lhasa", subBreed: nil),
                Breed(name: "malamute", subBreed: nil),
                Breed(name: "malinois", subBreed: nil),
                Breed(name: "maltese", subBreed: nil),
                Breed(name: "mastiff", subBreed: nil)
            ]
            return Just(mockBreeds)
                .delay(for: 0.1, scheduler: RunLoop.main)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        func getRandomImage(breed: Breed) -> AnyPublisher<ImageData, any Error> {
            return Fail(error: NetworkError.unexpected(message: ""))
                .eraseToAnyPublisher()
        }
    }

    private class MockGameStorage: GameStorageProtocol {
        func savePuppy(breed: Breed, imageURL: String) {
            fatalError()
        }
        
        func saveHiScore(_ score: Int, streak: Int) {
            fatalError()
        }
        
        func getHiScore() -> HiScores {
            fatalError()
        }
        
        func resetStorage() {
            fatalError()
        }
        
        func getAllDiscoveredBreeds() -> [Breed] {
            // Mock discovered breeds (subset of total breeds)
            return [
                Breed(name: "husky", subBreed: nil),
                Breed(name: "labrador", subBreed: nil),
                Breed(name: "mastiff", subBreed: nil),
                Breed(name: "malamute", subBreed: nil),
                Breed(name: "kelpie", subBreed: nil)
            ]
        }
        
        func getAllImageURLs(for breed: Breed) -> [String] {
            // Mock image URLs with your provided data
            return [
                "https://images.dog.ceo/breeds/terrier-norwich/n02094258_3036.jpg",
                "https://images.dog.ceo/breeds/ridgeback-rhodesian/n02087394_8903.jpg",
                "https://images.dog.ceo/breeds/whippet/n02091134_4273.jpg",
                "https://images.dog.ceo/breeds/basenji/n02110806_4280.jpg",
                "https://images.dog.ceo/breeds/malamute/n02110063_4432.jpg",
                "https://images.dog.ceo/breeds/finnish-lapphund/img_3801.jpg",
                "https://images.dog.ceo/breeds/terrier-westhighland/n02098286_278.jpg",
                "https://images.dog.ceo/breeds/african/n02116738_2802.jpg",
                "https://images.dog.ceo/breeds/keeshond/n02112350_9643.jpg",
                "https://images.dog.ceo/breeds/puggle/IMG_074532.jpg",
                "https://images.dog.ceo/breeds/gaddi-indian/Gaddi.jpg",
                "https://images.dog.ceo/breeds/mastiff-english/1.jpg",
                "https://images.dog.ceo/breeds/maltese/n02085936_9590.jpg",
                "https://images.dog.ceo/breeds/terrier-australian/n02096294_4583.jpg",
                "https://images.dog.ceo/breeds/labradoodle/lola.jpg"
            ]
        }
    }

}
