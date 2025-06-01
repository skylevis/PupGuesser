//
//  MockData.swift
//  PupGuesserTests
//
//  Created by See Soon Kiat on 1/6/25.
//

import Foundation
@testable import PupGuesser

var mockBreeds: [Breed] {
    rawMockBreeds.map { (breed: String, sub: [String]) in
        if sub.isEmpty {
            return sub.map { subBreed in
                return Breed(name: breed, subBreed: subBreed)
            }
        } else {
            return [Breed(name: breed, subBreed: nil)]
        }
    }
    .reduce([]) { partialResult, next in
        partialResult + next
    }
}

var mockImageData: [ImageData] {
    return [
        ImageData(url: "https://images.dog.ceo/breeds/rottweiler/n02106550_8437.jpg", data: Data()),
        ImageData(url: "https://images.dog.ceo/breeds/mix/nova1.jpg", data: Data()),
        ImageData(url: "https://images.dog.ceo/breeds/greyhound-indian/rampur-greyhound.jpg", data: Data())
    ]
}

private let rawMockBreeds = [
    "cotondetulear": [],
    "dachshund": [],
    "dalmatian": [],
    "dane": [
        "great"
    ],
    "danish": [
        "swedish"
    ],
    "deerhound": [
        "scottish"
    ],
    "dhole": [],
    "dingo": [],
    "doberman": [],
    "elkhound": [
        "norwegian"
    ],
    "entlebucher": [],
    "eskimo": [],
    "finnish": [
        "lapphund"
    ],
    "frise": [
        "bichon"
    ],
    "gaddi": [
        "indian"
    ],
    "germanshepherd": [],
    "greyhound": [
        "indian",
        "italian"
    ],
    "groenendael": [],
    "havanese": [],
    "hound": [
        "afghan",
        "basset",
        "blood",
        "english",
        "ibizan",
        "plott",
        "walker"
    ],
    "husky": [],
    "keeshond": [],
    "kelpie": [],
    "kombai": [],
    "komondor": [],
    "kuvasz": [],
    "labradoodle": [],
    "labrador": [],
    "leonberg": [],
    "lhasa": [],
    "malamute": [],
    "malinois": [],
    "maltese": [],
    "mastiff": [
        "bull",
        "english",
        "indian",
        "tibetan"
    ],
    "mexicanhairless": [],
    "mix": [],
    "mountain": [
        "bernese",
        "swiss"
    ],
    "mudhol": [
        "indian"
    ],
]
