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
    let code: Int?
    let status: String?
    let copyright: String?
    let attributionText: String?
    let attributionHTML: String?
    let data: MarvelData
    let etag: String?
    
}

struct MarvelData: Decodable {
    let results: [MarvelCharacterDecoder]
    let offset: Int?
    let limit: Int?
    let total: Int?
    let count: Int?
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
    private var limit = 100
    private var total = 0
    private var apiCallCount = 0
    
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
        
        // calcula o numero total de chamadas após a primeira resposta
        if total > 0 && allCharacters.count >= total {
            print("All characters have been fetched.")
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
                print("Network error: \(error.localizedDescription)")
                completion(.failure(.networkError(error)))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                print("Server error with status code: \(httpResponse.statusCode)")
                completion(.failure(.serverError(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                print("No data received from the server")
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                
                decoder.dateDecodingStrategy = .custom { decoder in
                    let container = try decoder.singleValueContainer()
                    let dateString = try container.decode(String.self)
                    
                    if let date = dateFormatter.date(from: dateString) {
                        return date
                    }
                    
                    print("Invalid date format: \(dateString)")
                    return Date(timeIntervalSince1970: 0)
                }
                
                let response = try decoder.decode(MarvelResponse.self, from: data)
                let characters = response.data.results
                
                self.allCharacters.append(contentsOf: characters)
                
                print("total of characters loaded until now: \(self.allCharacters.count)")
                
                if self.total == 0, let total = response.data.total {
                    self.total = total
                    print("total characters available from api: \(self.total)")
                }
                
                completion(.success(self.allCharacters))
                
                if self.allCharacters.count < self.total {
                    let newOffset = offset + self.limit
                    print("searching for more characters, new offset: \(newOffset)")
                    self.fetchCharactersWithOffset(offset: newOffset, completion: completion)
                } else {
                    print("all characters have been fetched successfully.")
                    completion(.success(self.allCharacters))
                }
                
            } catch {
                print("Decoding error: \(error)")
                print("Failed while decoding, data received may not match the expected structure.")
                completion(.failure(.decodingError))
            }
        }
        
        task.resume()
    }
}

