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
    let results: [MarvelCharacter]
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
    private var allCharacters: [MarvelCharacter] = []
    private var limit = 100
    private var total = 0
    private var apiCallCount = 0
    private let maxApiCalls = 1
    
    private let urlSession: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.urlSession = session
    }
        
    func fetchMarvelCharacters(completion: @escaping (Result<[MarvelCharacter], MarvelServiceError>) -> Void) {
           allCharacters.removeAll()
           apiCallCount = 0
           fetchCharactersWithOffset(offset: 0, completion: completion)
       }
       
       private func fetchCharactersWithOffset(offset: Int, completion: @escaping (Result<[MarvelCharacter], MarvelServiceError>) -> Void) {
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
                 //  print("JSON Response: \(jsonString)")
               }
               
               do {
                   let response = try JSONDecoder().decode(MarvelResponse.self, from: data)
                   
                   let characters = response.data.results
                   
//                   for character in characters {
//                       print("id: \(character.id ?? 0)")
//                       print("name: \(character.name ?? "no Name")")
//                       print("description: \(character.description ?? "no Description")")
//                   }
                   self.allCharacters.append(contentsOf: characters)
                   
                   print("total of patients loaded until now: \(self.allCharacters.count)")
                   
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
