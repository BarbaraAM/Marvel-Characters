//
//  CharacterService.swift
//  Marvel Characters
//
//  Created by Barbara Argolo on 25/09/24.
//

import Foundation

enum MarvelServiceError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(Int)
    case networkError(Error)
}

struct MarvelResponse: Decodable {
    let data: MarvelData
}

struct MarvelData: Decodable {
    let results: [MarvelCharacterDecoder]
    let total: Int
}


enum APIDomain: String {
    case marvelURL = "https://gateway.marvel.com:443/v1/public"
    
    static var current: APIDomain = .marvelURL
    
    func urlForEndpoint(_ endpoint: String, key: String) -> URL? {
        return URL(string: "\(self.rawValue)\(endpoint)?apikey=\(key)")
    }
}

enum CharactersEndpoint: String {
    case character = "/characters"
}

enum APIKey: String {
    case publicKey = "fccb36a6244ade40e0ec6d71c80334bc"
    case privateKey = "7fbca8f4deadd4e9bfca04ee4bfbdc102e555cd2"
}

class CharacterService: CharacterServiceProtocol {

    private var baseUrl = "https://gateway.marvel.com:443/v1/public/characters"
    private var allCharacters: [MarvelCharacterDecoder] = []
    private var limit = 10
    private var total = 0
    private var apiCallCount = 0
    private let maxApiCalls = 1
    
    private let urlSession: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.urlSession = session
    }
        
    func fetchMarvelCharacters(completion: @escaping (Result<[MarvelCharacterDecoder], MarvelServiceError>) -> Void) {
        allCharacters.removeAll()
        apiCallCount = 0
        fetchCharactersWithOffset(offset: 0, completion: completion)
    }
    
    private func fetchCharactersWithOffset(offset: Int, completion: @escaping (Result<[MarvelCharacterDecoder], MarvelServiceError>) -> Void) {
        if apiCallCount >= maxApiCalls {
            print("the call limit has been excedeed.")
            completion(.success(self.allCharacters))
            return
        }
        
        let ts = "\(Date().timeIntervalSince1970)"
        let stringToHash = ts + APIKey.privateKey.rawValue + APIKey.publicKey.rawValue
        let hash = stringToHash.md5()
        
        let urlString = "\(baseUrl)?limit=\(limit)&offset=\(offset)&ts=\(ts)&apikey=\(APIKey.publicKey.rawValue)&hash=\(hash)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        print("calling the url: \(urlString)")
        apiCallCount += 1
        
        let task = urlSession.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                completion(.failure(.serverError(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
             //     print("JSON Response: \(jsonString)")
            }
            
            do {
                let decoder = JSONDecoder()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                
                let response = try decoder.decode(MarvelResponse.self, from: data)
                let characters = response.data.results
                
                self.allCharacters.append(contentsOf: characters)
                
                print("total of patients loaded until now: \(self.allCharacters.count)")
                
                
//                  for character in characters {
//                      print("Character ID: \(character.id ?? 0)")
//                      print("Name: \(character.name ?? "N/A")")
//                      print("Description: \(character.description ?? "No description available")")
//                      print("Modified: \(character.modified?.description ?? "No modification date available")")
//                      print("Resource URI: \(character.resourceURI ?? "N/A")")
//                      
//                      if let urls = character.urls {
//                          for url in urls {
//                              print("URL Type: \(url.type ?? "N/A")")
//                              print("URL: \(url.url ?? "N/A")")
//                          }
//                      }
//                      
//                      if let thumbnail = character.thumbnail {
//                          print("Thumbnail Path: \(thumbnail.path ?? "N/A")")
//                          print("Thumbnail Extension: \(thumbnail.extension ?? "N/A")")
//                      }
//                      
//                      if let comics = character.comics {
//                          print("Comics Available: \(comics.available ?? 0)")
//                          print("Comics Returned: \(comics.returned ?? 0)")
//                          if let comicItems = comics.items {
//                              for comic in comicItems {
//                                  print("Comic Resource URI: \(comic.resourceURI ?? "N/A")")
//                                  print("Comic Name: \(comic.name ?? "N/A")")
//                              }
//                          }
//                      }
//                      
//                      if let stories = character.stories {
//                          print("Stories Available: \(stories.available ?? 0)")
//                          print("Stories Returned: \(stories.returned ?? 0)")
//                          if let storyItems = stories.items {
//                              for story in storyItems {
//                                  print("Story Resource URI: \(story.resourceURI ?? "N/A")")
//                                  print("Story Name: \(story.name ?? "N/A")")
//                                  print("Story Type: \(story.type ?? "N/A")")
//                              }
//                          }
//                      }
//                      
//                      if let events = character.events {
//                          print("Events Available: \(events.available ?? 0)")
//                          print("Events Returned: \(events.returned ?? 0)")
//                          if let eventItems = events.items {
//                              for event in eventItems {
//                                  print("Event Resource URI: \(event.resourceURI ?? "N/A")")
//                                  print("Event Name: \(event.name ?? "N/A")")
//                              }
//                          }
//                      }
//                      
//                      if let series = character.series {
//                          print("Series Available: \(series.available ?? 0)")
//                          print("Series Returned: \(series.returned ?? 0)")
//                          if let seriesItems = series.items {
//                              for series in seriesItems {
//                                  print("Series Resource URI: \(series.resourceURI ?? "N/A")")
//                                  print("Series Name: \(series.name ?? "N/A")")
//                              }
//                          }
//                      }
//                      
//                      print("------------------------------------------------")
//                  }
                
                if self.total == 0 {
                    self.total = response.data.total
                }
                
                completion(.success(self.allCharacters))
                
                if self.allCharacters.count < self.total && self.apiCallCount < self.maxApiCalls {
                    let newOffset = offset + self.limit
                    print("searching for new characters")
                    self.fetchCharactersWithOffset(offset: newOffset, completion: completion)
                } else if self.apiCallCount >= self.maxApiCalls {
                    completion(.success(self.allCharacters))
                }
                
            } catch {
                print("decoding error: \(error.localizedDescription)")
                completion(.failure(.decodingError))
            }
        }
        
        task.resume()
    }
}
