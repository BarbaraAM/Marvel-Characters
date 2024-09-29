//
//  CharacterServiceProtocol.swift
//  Marvel Characters
//
//  Created by Barbara Argolo on 26/09/24.
//

import Foundation

protocol CharacterServiceProtocol {
 
    func fetchMarvelCharacters(completion: @escaping (Result<[MarvelCharacterDecoder], MarvelServiceError>) -> Void)
    
}
