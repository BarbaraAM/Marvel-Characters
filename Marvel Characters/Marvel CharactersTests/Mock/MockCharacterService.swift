//
//  MockCharacterService.swift
//  Marvel CharactersTests
//
//  Created by Barbara Argolo on 26/09/24.
//

import Foundation
@testable import Marvel_Characters


//herda o protocolo
class MockCharacterService: CharacterServiceProtocol {
    var shouldReturnError = false
    var mockCharacters: [MarvelCharacter] = [
        MarvelCharacter(id: 1, name: "Iron Man", characterDescription: "the Iron Man"),
        MarvelCharacter(id: 1, name: "Black Widow", characterDescription: "The Black Widow")
    ]
    
    func fetchMarvelCharacters(completion: @escaping (Result<[MarvelCharacter], MarvelServiceError>) -> Void) {
        if shouldReturnError {
            completion(.failure(.noData))
        } else {
            completion(.success(mockCharacters))
        }
    }
    
}
