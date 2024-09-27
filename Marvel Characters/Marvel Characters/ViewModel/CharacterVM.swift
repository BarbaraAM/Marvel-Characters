//
//  CharacterVM.swift
//  Marvel Characters
//
//  Created by Barbara Argolo on 25/09/24.
//

import Foundation

class CharacterVM {
    
    private let coordinator: AppCoordinating?
    //configuring the protocol to test
    private let characterService: CharacterServiceProtocol
    
    var characters: [MarvelCharacter] = [] {
        didSet {
            filteredCharacters = characters
            onCharactersUpdated?()
        }
    }
    var filteredCharacters: [MarvelCharacter] = []
    
    var onCharactersUpdated: (() -> Void)?
    
    var onFetchError: ((String) -> Void)?
    
    //passando uma instancia para uma classe que conforma o protocolo
    init(coordinator: AppCoordinating? = nil, characterService: CharacterServiceProtocol = CharacterService()) {
        self.coordinator = coordinator
        self.characterService = characterService
    }
    
    func fetchCharacters() {
        characterService.fetchMarvelCharacters { [weak self] result in
            switch result {
            case .success(let characters):
                self?.characters = characters
            case .failure(let error):
                self?.handleError(error)
            }
        }
    }
    
    private func handleError(_ error: MarvelServiceError) {
        var errorMessage = ""
        
        switch error {
        case .invalidURL:
            errorMessage = "A URL da API é inválida."
        case .noData:
            errorMessage = "Nenhum dado foi recebido."
        case .decodingError:
            errorMessage = "Erro ao decodificar a resposta da API."
        case .serverError(let statusCode):
            errorMessage = "Erro no servidor: Código \(statusCode)"
        case .networkError(let networkError):
            errorMessage = "Erro de conexão: \(networkError.localizedDescription)"
        }
        
        DispatchQueue.main.async {
            self.onFetchError?(errorMessage)
        }
    }
    
    func didSelectCharacter(_ character: MarvelCharacter) {
        if let coordinator = coordinator {
            coordinator.showCharacterDetail(for: character)
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
}

