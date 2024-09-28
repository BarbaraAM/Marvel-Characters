//
//  CharacterDetailsVM.swift
//  Marvel Characters
//
//  Created by Barbara Argolo on 26/09/24.
//

import Foundation

class CharacterDetailViewModel {
    private let character: MarvelCharacterDecoder
    
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
    
    init(character: MarvelCharacterDecoder) {
        self.character = character
    }
}

