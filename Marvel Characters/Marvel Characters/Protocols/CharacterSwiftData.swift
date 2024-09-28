//
//  CharacterSwiftData.swift
//  Marvel Characters
//
//  Created by Barbara Argolo on 28/09/24.
//

import Foundation

protocol CharacterSwiftDataDataManaging {
    func saveCharacterToStorage(_ character: MarvelCharacterStorage)
    func fetchStoredCharacters(completion: @escaping (Result<[MarvelCharacterStorage], Error>) -> Void)
    func deleteCharacter(byId id: Int)
}
