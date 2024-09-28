//
//  CharacterDetailsVM.swift
//  Marvel Characters
//
//  Created by Barbara Argolo on 26/09/24.
//

import Foundation
import UIKit

class CharacterDetailViewModel {
    private let character: MarvelCharacterDecoder
    private let listVM: ListViewModel
    private let index: Int
    private let coordinator: AppCoordinating
    private var filteredCharacters: [MarvelCharacterDecoder]

    var isFavorited = false
    
 
    
    init(character: MarvelCharacterDecoder, listVM: ListViewModel, index: Int, filteredCharacters: [MarvelCharacterDecoder], coordinator: AppCoordinating) {
         self.character = character
         self.listVM = listVM
         self.index = index
         self.filteredCharacters = filteredCharacters
        self.coordinator = coordinator
         updateFavoriteStatus()
     }
    
    // to favorite and unfavorite characters in Detail View
    
    func favoriteCharacter() {
        listVM.filteredCharacters = filteredCharacters
        listVM.favoriteCharacter(by: character.id ?? 1)
      }
      
      func unfavoriteCharacter() {
          
          listVM.filteredCharacters = filteredCharacters
          listVM.unfavoriteCharacter(by: character.id ?? 1)
      }
    
    func updateFavoriteStatus() {
        isFavorited = listVM.isCharacterFavorited(character)
    }
    
    func toggleFavoriteStatus() {
        if isFavorited {
            unfavoriteCharacter()
        } else {
            favoriteCharacter()
        }
    }
    
    func didTapShare() {
        guard let imageUrl = imageUrl else {
            DispatchQueue.main.async {
                self.coordinator.showErrorMessage("Imagem não disponível para compartilhamento.")
            }
            return
        }
        
        downloadImage(from: imageUrl) { [weak self] image in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let image = image {
                    self.coordinator.shareCharacterImage(image: image)
                } else {
                    self.coordinator.showErrorMessage("Falha ao carregar a imagem para compartilhamento.")
                }
            }
        }
    }
    
    private func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }.resume()
    }
    
    
    var name: String {
        return character.name ?? "Unknown"
    }
    
    var description: String {
        return character.description?.isEmpty == false ? character.description! : "No description available for this character."
    }
    
    var imageUrl: URL? {
        return character.thumbnail?.imageURL
    }
    
    var comics: String {
        let comicNames = character.comics?.items?.compactMap { $0.name } ?? []
        return comicNames.isEmpty ? "No comics available" : comicNames.joined(separator: ", ")
    }
    
    var series: String {
        let seriesNames = character.series?.items?.compactMap { $0.name } ?? []
        return seriesNames.isEmpty ? "No series available" : seriesNames.joined(separator: ", ")
    }
    
    var stories: String {
        let storyNames = character.stories?.items?.compactMap { $0.name } ?? []
        return storyNames.isEmpty ? "No stories available" : storyNames.joined(separator: ", ")
    }
    
    var events: String {
        let eventNames = character.events?.items?.compactMap { $0.name } ?? []
        return eventNames.isEmpty ? "No events available" : eventNames.joined(separator: ", ")
    }
    
    var resourceURI: String {
        return character.resourceURI ?? "No resource URI available"
    }
    
    var urls: String {
        let urlList = character.urls?.compactMap { "\($0.type ?? "N/A"): \($0.url ?? "N/A")" } ?? []
        return urlList.isEmpty ? "No URLs available" : urlList.joined(separator: "\n")
    }
    
}

