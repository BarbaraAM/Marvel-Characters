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
    var mockCharacters: [MarvelCharacterDecoder] = [
    ]
    
    func fetchMarvelCharacters(completion: @escaping (Result<[MarvelCharacterDecoder], MarvelServiceError>) -> Void) {
        if shouldReturnError {
            completion(.failure(.noData))
        } else {
            completion(.success(mockCharacters))
        }
    }
    
}
