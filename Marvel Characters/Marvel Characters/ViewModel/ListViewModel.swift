//
//  CharacterVM.swift
//  Marvel Characters
//
//  Created by Barbara Argolo on 25/09/24.
//

import Foundation

class ListViewModel {
    
    private let coordinator: AppCoordinating?
    //configuring the protocol to test
    private let characterService: CharacterServiceProtocol
    private var characterManager: CharacterSwiftDataDataManaging
//    private let characterManager = CharactersSwiftDataManager.shared
    private var hasConnectionIssue = false
    
    var characters: [MarvelCharacterDecoder] = [] {
        didSet {
            filteredCharacters = characters
            onCharactersUpdated?()
        }
    }
    var filteredCharacters: [MarvelCharacterDecoder] = []
    
    var onCharactersUpdated: (() -> Void)?
    
    var onFetchError: ((String) -> Void)?
    
    //passando uma instancia para uma classe que conforma o protocolo
    init(coordinator: AppCoordinating? = nil, characterService: CharacterServiceProtocol = CharacterService(), characterManager: CharacterSwiftDataDataManaging = CharactersSwiftDataManager.shared) {
        self.coordinator = coordinator
        self.characterService = characterService
        self.characterManager = characterManager
    }
    
    func fetchCharacters() {
        characterService.fetchMarvelCharacters { [weak self] result in
            
           // print("result in list \(result)")
            switch result {
            case .success(let characters):
                self?.characters = characters
            case .failure(let error):
                self?.characterManager.fetchStoredCharacters { [weak self] fetchResult in
                    switch fetchResult {
                    case .success(let storedCharacters):
                        if storedCharacters.isEmpty {
                            print("No locally stored characters found.")
                        } else {
                            
                            print("Loaded \(storedCharacters.count) characters from local storage.")
                            let convertedCharacters = storedCharacters.map { MarvelCharacterDecoder(from: $0) }
                            self?.characters = convertedCharacters
                            self?.onCharactersUpdated?()
                        }
                    case .failure(let fetchError):
                        print("Failed to fetch stored characters: \(fetchError.localizedDescription)")
                    }
                }
                self?.handleError(error)
            }
        }
    }
    
    private func handleError(_ error: MarvelServiceError) {
        var errorMessage = ""
        
        switch error {
        case .invalidURL:
            errorMessage = "Oops! Parece que há um problema com a URL da API. Por favor, tente novamente mais tarde."
        case .noData:
            errorMessage = "Nenhum dado foi recebido. Pode ser que nossa conexão com o universo Marvel esteja instável. Tente novamente em breve."
        case .decodingError:
            errorMessage = "Houve um erro ao interpretar os dados recebidos. Por favor, tente novamente."
        case .serverError(let statusCode):
            errorMessage = "Parece que o servidor está com problemas. (Código do erro: \(statusCode)). Por favor, tente mais tarde."
        case .networkError(let networkError):
            errorMessage = "Problema de conexão: \(networkError.localizedDescription). Verifique sua internet e tente novamente."
        }
        DispatchQueue.main.async {
            self.onFetchError?(errorMessage)
            self.hasConnectionIssue = true
        }
    }
    
    func didSelectCharacter(_ character: MarvelCharacterDecoder, index: Int ) {
        if let coordinator = coordinator {
            coordinator.showCharacterDetail(for: character,  at: index, filteredCharacters: filteredCharacters)
        } else {
            print("No coordinator available.")
        }
    }
    
    //filter characters by name
    
    func filterCharacters(with names: String) {
        if names.isEmpty {
            filteredCharacters = characters
        } else {
            filteredCharacters = characters.filter { $0.name?.lowercased().contains(names.lowercased()) == true }
        }
        onCharactersUpdated?()
    }
    
    
    func isCharacterFavorited(_ character: MarvelCharacterDecoder) -> Bool {
        guard let characterId = character.id else {
            return false
        }
        
        return characterManager.isCharacterFavorited(byId: characterId)
    }
    func favoriteCharacter(by id: Int) {
        if let index = filteredCharacters.firstIndex(where: { $0.id == id }) {
            let characterDecoded = filteredCharacters[index]
            let storageCharacter = characterManager.convertDecoderToStorage(for: characterDecoded)
            characterManager.saveCharacterToStorage(storageCharacter)
            onCharactersUpdated?()
        }
    }
    
    func unfavoriteCharacter(by id: Int) {
        print("filtered characters \(filteredCharacters)")
        if let index = filteredCharacters.firstIndex(where: { $0.id == id }) {
            let characterDecoded = filteredCharacters[index]
            
            if let characterId = characterDecoded.id {
                characterManager.deleteCharacter(byId: characterId)
            }
            //if has a connection issue, remove from the list and swiftdata
            if hasConnectionIssue {
                filteredCharacters.remove(at: index)
                onCharactersUpdated?()
            } else {
                //here removes only in swiftdata without removing from UI
                onCharactersUpdated?()
            }
        }
    }
}

