//
//  SwiftDataManager.swift
//  Marvel Characters
//
//  Created by Barbara Argolo on 27/09/24.
//

import Foundation
import SwiftData

class CharactersSwiftDataManager: CharacterSwiftDataDataManaging {

    static let shared = CharactersSwiftDataManager()
    
    var container: ModelContainer?
    var context: ModelContext?
    
    private init() {
        do {
            let schema = Schema([MarvelCharacterStorage.self])
            
            let modelConfig = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            container = try ModelContainer(for: schema, configurations: [modelConfig])
            
            if let container {
                context = ModelContext(container)
            } else {
                print("no container.")
            }
        } catch {
            print("Error to init container. \(error)")
        }
    }
    
    func convertDecoderToStorage(for model: MarvelCharacterDecoder) -> MarvelCharacterStorage {
        let id = model.id ?? 0
        let name = model.name ?? "Unknown"
        let characterDescription = model.description ?? "No description available"
        let resourceURI = model.resourceURI ?? ""
        
        let urls = mapUrls(model.urls)
        let thumbnail = mapThumbnail(model.thumbnail)
        let comics = mapComicList(model.comics)
        let stories = mapStoryList(model.stories)
        let events = mapEventList(model.events)
        let series = mapSeriesList(model.series)
        
        return MarvelCharacterStorage(
            id: id,
            name: name,
            characterDescription: characterDescription,
            resourceURI: resourceURI,
            urls: urls,
            thumbnail: thumbnail,
            comics: comics,
            stories: stories,
            events: events,
            series: series
        )
    }

    private func mapUrls(_ urls: [UrlDecoder]?) -> [Url] {
        return urls?.compactMap {
            guard let type = $0.type, let urlString = $0.url else { return nil }
            let urlObject = Url(type: type, url: urlString)
            CharactersSwiftDataManager.shared.context?.insert(urlObject)
            saveContext()
            return urlObject
        } ?? []
    }

    private func mapThumbnail(_ thumbnail: ThumbnailDecoder?) -> Thumbnail? {
        guard let thumbnail = thumbnail else { return nil }
        let thumbnailObject = Thumbnail(path: thumbnail.path, extension: thumbnail.extension)
        CharactersSwiftDataManager.shared.context?.insert(thumbnailObject)
        saveContext()
        return thumbnailObject
    }

    private func mapComicList(_ comicList: ComicListDecoder?) -> ComicList? {
        return comicList.map { list in
            let items = list.items?.compactMap { item -> ComicSummary? in
                guard let resourceURI = item.resourceURI, let name = item.name else { return nil }
                return ComicSummary(resourceURI: resourceURI, name: name)
            } ?? []
            
            return ComicList(
                available: list.available ?? 0,
                collectionURI: list.collectionURI ?? "",
                items: items,
                returned: list.returned ?? 0
            )
        }
    }

    private func mapStoryList(_ storyList: StoryListDecoder?) -> StoryList? {
        return storyList.map { list in
            let items = list.items?.compactMap { item -> StorySummary? in
                guard let resourceURI = item.resourceURI, let name = item.name, let type = item.type else { return nil }
                return StorySummary(resourceURI: resourceURI, name: name, type: type)
            } ?? []
            
            return StoryList(
                available: list.available ?? 0,
                collectionURI: list.collectionURI ?? "",
                items: items,
                returned: list.returned ?? 0
            )
        }
    }

    private func mapEventList(_ eventList: EventListDecoder?) -> EventList? {
        return eventList.map { list in
            let items = list.items?.compactMap { item -> EventSummary? in
                guard let resourceURI = item.resourceURI, let name = item.name else { return nil }
                return EventSummary(resourceURI: resourceURI, name: name)
            } ?? []
            
            return EventList(
                available: list.available ?? 0,
                collectionURI: list.collectionURI ?? "",
                items: items,
                returned: list.returned ?? 0
            )
        }
    }

    private func mapSeriesList(_ seriesList: SeriesListDecoder?) -> SeriesList? {
        return seriesList.map { list in
            let items = list.items?.compactMap { item -> SeriesSummary? in
                guard let resourceURI = item.resourceURI, let name = item.name else { return nil }
                return SeriesSummary(resourceURI: resourceURI, name: name)
            } ?? []
            
            return SeriesList(
                available: list.available ?? 0,
                collectionURI: list.collectionURI ?? "",
                items: items,
                returned: list.returned ?? 0
            )
        }
    }

    private func saveContext() {
        do {
            try CharactersSwiftDataManager.shared.context?.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }

    func isCharacterFavorited(byId characterId: Int) -> Bool {
            guard let context = context else {
                print("Context is not initialized")
                return false
            }
            
            let fetchDescriptor = FetchDescriptor<MarvelCharacterStorage>(
                predicate: #Predicate { $0.id == characterId }
            )
            
            do {
                let results = try context.fetch(fetchDescriptor)
                return !results.isEmpty
            } catch {
                print("Error checking if character is favorited: \(error)")
                return false
            }
        }
    
    
    func saveCharacterToStorage(_ character: MarvelCharacterStorage) {

        do {
            try context?.insert(character)
            
            try context?.save()
            
            print("Character saved successfully in SwiftData!")
        } catch {
            print("Failed to save character to SwiftData: \(error.localizedDescription)")
        }
    }
    
    func fetchStoredCharacters(completion: @escaping (Result<[MarvelCharacterStorage], Error>) -> Void) {
        let fetchDescriptor = FetchDescriptor<MarvelCharacterStorage>()
        
        do {
            if let storedCharacters = try context?.fetch(fetchDescriptor) {
                completion(.success(storedCharacters))
            } else {
                completion(.success([]))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func deleteCharacter(byId id: Int) {
        let descriptor = FetchDescriptor<MarvelCharacterStorage>(
            predicate: #Predicate { $0.id == id }
        )
        
        do {
            if let characterToDelete = try context?.fetch(descriptor).first {
                context?.delete(characterToDelete)
                try context?.save()
                print("Character with ID \(id) successfully deleted from storage.")
            } else {
                print("No character found with ID \(id) in storage.")
            }
        } catch {
            print("Failed to delete character: \(error.localizedDescription)")
        }
    }
}
