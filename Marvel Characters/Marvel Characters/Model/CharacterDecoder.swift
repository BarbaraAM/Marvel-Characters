//
//  CharacterDecoder.swift
//  Marvel Characters
//
//  Created by Barbara Argolo on 28/09/24.
//

import Foundation



struct MarvelCharacterDecoder: Decodable {
    let id: Int?
    let name: String?
    let description: String?
    let modified: String?
    let resourceURI: String?
    let urls: [UrlDecoder]?
    let thumbnail: ThumbnailDecoder?
    let comics: ComicListDecoder?
    let stories: StoryListDecoder?
    let events: EventListDecoder?
    let series: SeriesListDecoder?
    
    
    
    var modifiedDate: Date? {
        guard let modified = modified else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: modified)
    }
    
    //convert the relationships
    init(from storage: MarvelCharacterStorage) {
        self.id = storage.id
        self.name = storage.name
        self.description = storage.characterDescription
        self.modified = storage.modified
        self.resourceURI = storage.resourceURI
        self.urls = storage.urls?.map { UrlDecoder(from: $0) }
        self.thumbnail = storage.thumbnail.map { ThumbnailDecoder(from: $0) }
        self.comics = storage.comics.map { ComicListDecoder(from: $0) }
        self.stories = storage.stories.map { StoryListDecoder(from: $0) }
        self.events = storage.events.map { EventListDecoder(from: $0) }
        self.series = storage.series.map { SeriesListDecoder(from: $0) }
    }
    
    
}

struct UrlDecoder: Decodable {
    let type: String?
    let url: String?
    
    init(from storage: Url) {
        self.type = storage.type
        self.url = storage.url
    }
}

struct ThumbnailDecoder: Decodable {
    let path: String?
    let `extension`: String?
    
    var imageURL: URL? {
        guard let path = path, let ext = `extension` else {
            return nil
        }
        
        let securePath = path.replacingOccurrences(of: "http", with: "https")
        return URL(string: "\(securePath).\(ext)")
    }
    init(from storage: Thumbnail) {
        self.path = storage.path
        self.`extension` = storage.`extension`
    }

    enum CodingKeys: String, CodingKey {
        case path
        case `extension` = "extension"
    }
}

struct ComicListDecoder: Decodable {
    let available: Int?
      let collectionURI: String?
      let items: [ComicSummaryDecoder]?
      let returned: Int?

      init(from storage: ComicList) {
          self.available = storage.available
          self.collectionURI = storage.collectionURI
          self.items = storage.items?.map { ComicSummaryDecoder(from: $0) }
          self.returned = storage.returned
      }
}

struct ComicSummaryDecoder: Codable {
    let resourceURI: String?
    let name: String?

    init(from storage: ComicSummary) {
        self.resourceURI = storage.resourceURI
        self.name = storage.name
    }
}

struct StoryListDecoder: Decodable {
    let available: Int?
    let returned: Int?
    let collectionURI: String?
    let items: [StorySummaryDecoder]?

    init(from storage: StoryList) {
        self.available = storage.available
        self.returned = storage.returned
        self.collectionURI = storage.collectionURI
        self.items = storage.items?.map { StorySummaryDecoder(from: $0) }
    }
}

struct StorySummaryDecoder: Decodable {
    let resourceURI: String?
    let name: String?
    let type: String?

    init(from storage: StorySummary) {
        self.resourceURI = storage.resourceURI
        self.name = storage.name
        self.type = storage.type
    }
}

struct EventListDecoder: Decodable {
    let available: Int?
    let returned: Int?
    let collectionURI: String?
    let items: [EventSummaryDecoder]?

    init(from storage: EventList) {
        self.available = storage.available
        self.returned = storage.returned
        self.collectionURI = storage.collectionURI
        self.items = storage.items?.map { EventSummaryDecoder(from: $0) }
    }
}

struct EventSummaryDecoder: Decodable {
    let resourceURI: String?
    let name: String?

    init(from storage: EventSummary) {
        self.resourceURI = storage.resourceURI
        self.name = storage.name
    }
}

struct SeriesListDecoder: Decodable {
    let available: Int?
    let returned: Int?
    let collectionURI: String?
    let items: [SeriesSummaryDecoder]?

    init(from storage: SeriesList) {
        self.available = storage.available
        self.returned = storage.returned
        self.collectionURI = storage.collectionURI
        self.items = storage.items?.map { SeriesSummaryDecoder(from: $0) }
    }
}

struct SeriesSummaryDecoder: Decodable {
    let resourceURI: String?
    let name: String?

    init(from storage: SeriesSummary) {
        self.resourceURI = storage.resourceURI
        self.name = storage.name
    }
}
