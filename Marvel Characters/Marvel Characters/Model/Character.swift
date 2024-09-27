//
//  Character.swift
//  Marvel Characters
//
//  Created by Barbara Argolo on 25/09/24.
//

import Foundation
import SwiftData

@Model
class MarvelCharacter: Codable {
    let id: Int?
    let name: String?
    let characterDescription: String?
    let resourceURI: String?
    @Relationship(deleteRule: .cascade) var urls: [Url]?
    @Relationship(deleteRule: .cascade) var thumbnail: Thumbnail?
    @Relationship(deleteRule: .cascade) var comics: ComicList?
    @Relationship(deleteRule: .cascade) var stories: StoryList?
    @Relationship(deleteRule: .cascade) var events: EventList?
    @Relationship(deleteRule: .cascade) var series: SeriesList?
    
    convenience init(id: Int, name: String, characterDescription: String) {
        self.init(id: id, name: name, characterDescription: characterDescription, resourceURI: nil, urls: nil, thumbnail: nil, comics: nil, stories: nil, events: nil, series: nil)
    }
    
    convenience init(id: Int, name: String) {
        self.init(id: id, name: name, characterDescription: nil, resourceURI: nil, urls: nil, thumbnail: nil, comics: nil, stories: nil, events: nil, series: nil)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case characterDescription = "description"
        case resourceURI
        case urls
        case thumbnail
        case comics
        case stories
        case events
        case series
    }
    init(id: Int?, name: String?, characterDescription: String?, resourceURI: String?, urls: [Url]?, thumbnail: Thumbnail?, comics: ComicList?, stories: StoryList?, events: EventList?, series: SeriesList?) {
        self.id = id
        self.name = name
        self.characterDescription = characterDescription
        self.resourceURI = resourceURI
        self.urls = urls
        self.thumbnail = thumbnail
        self.comics = comics
        self.stories = stories
        self.events = events
        self.series = series
    }
    
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.characterDescription = try container.decodeIfPresent(String.self, forKey: .characterDescription)
        self.resourceURI = try container.decodeIfPresent(String.self, forKey: .resourceURI)
        self.urls = try container.decodeIfPresent([Url].self, forKey: .urls)
        self.thumbnail = try container.decodeIfPresent(Thumbnail.self, forKey: .thumbnail)
        self.comics = try container.decodeIfPresent(ComicList.self, forKey: .comics)
        self.stories = try container.decodeIfPresent(StoryList.self, forKey: .stories)
        self.events = try container.decodeIfPresent(EventList.self, forKey: .events)
        self.series = try container.decodeIfPresent(SeriesList.self, forKey: .series)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(characterDescription, forKey: .characterDescription)
        try container.encodeIfPresent(resourceURI, forKey: .resourceURI)
        try container.encodeIfPresent(urls, forKey: .urls)
        try container.encodeIfPresent(thumbnail, forKey: .thumbnail)
        try container.encodeIfPresent(comics, forKey: .comics)
        try container.encodeIfPresent(stories, forKey: .stories)
        try container.encodeIfPresent(events, forKey: .events)
        try container.encodeIfPresent(series, forKey: .series)
    }
}

@Model
class Url: Codable {
    let type: String?
    let url: String?

    init(type: String?, url: String?) {
        self.type = type
        self.url = url
    }

    enum CodingKeys: String, CodingKey {
        case type
        case url
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.url = try container.decodeIfPresent(String.self, forKey: .url)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(url, forKey: .url)
    }
}

@Model
class Thumbnail: Codable {
    let path: String
    let `extension`: String

    var imageURL: URL? {
        let securePath = path.replacingOccurrences(of: "http", with: "https")
        return URL(string: "\(securePath).\(`extension`)")
    }

    init(path: String, `extension`: String) {
        self.path = path
        self.`extension` = `extension`
    }

    enum CodingKeys: String, CodingKey {
        case path
        case `extension` = "extension"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.path = try container.decode(String.self, forKey: .path)
        self.`extension` = try container.decode(String.self, forKey: .`extension`)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(path, forKey: .path)
        try container.encode(`extension`, forKey: .`extension`)
    }
}

@Model
class ComicList: Codable {
    let available: Int?
    let collectionURI: String?
    @Relationship(deleteRule: .cascade) var items: [ComicSummary]?
    let returned: Int?

    init(available: Int?, collectionURI: String?, items: [ComicSummary]?, returned: Int?) {
        self.available = available
        self.collectionURI = collectionURI
        self.items = items
        self.returned = returned
    }

    enum CodingKeys: String, CodingKey {
        case available
        case collectionURI
        case items
        case returned
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.available = try container.decodeIfPresent(Int.self, forKey: .available)
        self.collectionURI = try container.decodeIfPresent(String.self, forKey: .collectionURI)
        self.items = try container.decodeIfPresent([ComicSummary].self, forKey: .items)
        self.returned = try container.decodeIfPresent(Int.self, forKey: .returned)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(available, forKey: .available)
        try container.encodeIfPresent(collectionURI, forKey: .collectionURI)
        try container.encodeIfPresent(items, forKey: .items)
        try container.encodeIfPresent(returned, forKey: .returned)
    }
}

@Model
class ComicSummary: Codable {
    let resourceURI: String?
    let name: String?

    init(resourceURI: String?, name: String?) {
        self.resourceURI = resourceURI
        self.name = name
    }

    enum CodingKeys: String, CodingKey {
        case resourceURI
        case name
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.resourceURI = try container.decodeIfPresent(String.self, forKey: .resourceURI)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(resourceURI, forKey: .resourceURI)
        try container.encodeIfPresent(name, forKey: .name)
    }
}

@Model
class StoryList: Codable {
    let available: Int?
    let collectionURI: String?
    @Relationship(deleteRule: .cascade) var items: [StorySummary]?
    let returned: Int?

    init(available: Int?, collectionURI: String?, items: [StorySummary]?, returned: Int?) {
        self.available = available
        self.collectionURI = collectionURI
        self.items = items
        self.returned = returned
    }

    enum CodingKeys: String, CodingKey {
        case available
        case collectionURI
        case items
        case returned
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.available = try container.decodeIfPresent(Int.self, forKey: .available)
        self.collectionURI = try container.decodeIfPresent(String.self, forKey: .collectionURI)
        self.items = try container.decodeIfPresent([StorySummary].self, forKey: .items)
        self.returned = try container.decodeIfPresent(Int.self, forKey: .returned)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(available, forKey: .available)
        try container.encodeIfPresent(collectionURI, forKey: .collectionURI)
        try container.encodeIfPresent(items, forKey: .items)
        try container.encodeIfPresent(returned, forKey: .returned)
    }
}

@Model
class StorySummary: Codable {
    let resourceURI: String?
    let name: String?
    let type: String?

    init(resourceURI: String?, name: String?, type: String?) {
        self.resourceURI = resourceURI
        self.name = name
        self.type = type
    }

    enum CodingKeys: String, CodingKey {
        case resourceURI
        case name
        case type
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.resourceURI = try container.decodeIfPresent(String.self, forKey: .resourceURI)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(resourceURI, forKey: .resourceURI)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(type, forKey: .type)
    }
}

@Model
class SeriesList: Codable {
    let available: Int?
    let collectionURI: String?
    @Relationship(deleteRule: .cascade) var items: [SeriesSummary]?
    let returned: Int?

    init(available: Int?, collectionURI: String?, items: [SeriesSummary]?, returned: Int?) {
        self.available = available
        self.collectionURI = collectionURI
        self.items = items
        self.returned = returned
    }

    enum CodingKeys: String, CodingKey {
        case available
        case collectionURI
        case items
        case returned
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.available = try container.decodeIfPresent(Int.self, forKey: .available)
        self.collectionURI = try container.decodeIfPresent(String.self, forKey: .collectionURI)
        self.items = try container.decodeIfPresent([SeriesSummary].self, forKey: .items)
        self.returned = try container.decodeIfPresent(Int.self, forKey: .returned)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(available, forKey: .available)
        try container.encodeIfPresent(collectionURI, forKey: .collectionURI)
        try container.encodeIfPresent(items, forKey: .items)
        try container.encodeIfPresent(returned, forKey: .returned)
    }
}

@Model
class SeriesSummary: Codable {
    let resourceURI: String?
    let name: String?

    init(resourceURI: String?, name: String?) {
        self.resourceURI = resourceURI
        self.name = name
    }

    enum CodingKeys: String, CodingKey {
        case resourceURI
        case name
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.resourceURI = try container.decodeIfPresent(String.self, forKey: .resourceURI)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(resourceURI, forKey: .resourceURI)
        try container.encodeIfPresent(name, forKey: .name)
    }
}

@Model
class EventList: Codable {
    let available: Int?
    let collectionURI: String?
    @Relationship(deleteRule: .cascade) var items: [EventSummary]?
    let returned: Int?

    init(available: Int?, collectionURI: String?, items: [EventSummary]?, returned: Int?) {
        self.available = available
        self.collectionURI = collectionURI
        self.items = items
        self.returned = returned
    }

    enum CodingKeys: String, CodingKey {
        case available
        case collectionURI
        case items
        case returned
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.available = try container.decodeIfPresent(Int.self, forKey: .available)
        self.collectionURI = try container.decodeIfPresent(String.self, forKey: .collectionURI)
        self.items = try container.decodeIfPresent([EventSummary].self, forKey: .items)
        self.returned = try container.decodeIfPresent(Int.self, forKey: .returned)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(available, forKey: .available)
        try container.encodeIfPresent(collectionURI, forKey: .collectionURI)
        try container.encodeIfPresent(items, forKey: .items)
        try container.encodeIfPresent(returned, forKey: .returned)
    }
}

@Model
class EventSummary: Codable {
    let resourceURI: String?
    let name: String?

    init(resourceURI: String?, name: String?) {
        self.resourceURI = resourceURI
        self.name = name
    }

    enum CodingKeys: String, CodingKey {
        case resourceURI
        case name
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.resourceURI = try container.decodeIfPresent(String.self, forKey: .resourceURI)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(resourceURI, forKey: .resourceURI)
        try container.encodeIfPresent(name, forKey: .name)
    }
}

