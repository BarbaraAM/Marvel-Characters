//
//  CharacterDetailsVM.swift
//  Marvel Characters
//
//  Created by Barbara Argolo on 26/09/24.
//

import Foundation

class CharacterDetailViewModel {
    private let character: MarvelCharacter
    
    var name: String {
        return character.name ?? "Unknown"
    }
    
    var description: String {
        return character.characterDescription?.isEmpty == false ? character.characterDescription! : "No description available for this character."
    }
    
    var imageUrl: URL? {
        return character.thumbnail?.imageURL
    }
    
    init(character: MarvelCharacter) {
        self.character = character
    }
}
