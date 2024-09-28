//
//  CharacterServiceProtocol.swift
//  Marvel Characters
//
//  Created by Barbara Argolo on 26/09/24.
//

import Foundation

protocol CharacterServiceProtocol {
    //precisa de uma conexão por protocolo para substituir CharacterService no lugar de MockCharacterService
    func fetchMarvelCharacters(completion: @escaping (Result<[MarvelCharacterDecoder], MarvelServiceError>) -> Void)
    
}
