//
//  CharacterSwiftdataMock.swift
//  Marvel CharactersTests
//
//  Created by Barbara Argolo on 28/09/24.
//

import Foundation
import SwiftData
@testable import Marvel_Characters

//
class SwiftDataMock: CharacterSwiftDataDataManaging {
  
    var container: ModelContainer?
    var context: ModelContext?

    init() {
        do {
            let schema = Schema([MarvelCharacterStorage.self])
            let modelConfig = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
            
            container = try ModelContainer(for: schema, configurations: [modelConfig])
            
            if let container {
                context = ModelContext(container)
            } else {
                print("Failed to initialize container.")
            }
        } catch {
            print("Error initializing SwiftDataMock container: \(error)")
        }
    }
    
    func saveCharacterToStorage(_ character: MarvelCharacterStorage) {
         do {
             context?.insert(character)
             try context?.save()
             print("Mock character saved successfully in SwiftData.")
         } catch {
             print("Failed to save character in SwiftDataMock: \(error)")
         }
     }
     
     func fetchStoredCharacters(completion: @escaping (Result<[MarvelCharacterStorage], Error>) -> Void) {
         let fetchDescriptor = FetchDescriptor<MarvelCharacterStorage>(sortBy: [SortDescriptor(\.name)])
         
         do {
             let results = try context?.fetch(fetchDescriptor)
             completion(.success(results ?? []))
         } catch {
             print("Failed to fetch characters from SwiftDataMock: \(error)")
             completion(.failure(error))
         }
     }
     
     func deleteCharacter(byId id: Int) {
         if let character = fetchCharacters().first(where: { $0.id == id }) {
             context?.delete(character)
             
             do {
                 try context?.save()
                 print("Character \(character.name ?? "") deleted successfully from SwiftDataMock.")
             } catch {
                 print("Failed to delete character from SwiftDataMock: \(error)")
             }
         }
     }
     
     // aux func to unit tests without completion
    func fetchCharacters() -> [MarvelCharacterStorage] {
         let fetchDescriptor = FetchDescriptor<MarvelCharacterStorage>(sortBy: [SortDescriptor(\.name)])
         
         do {
             let results = try context?.fetch(fetchDescriptor)
             return results ?? []
         } catch {
             print("Failed to fetch characters from SwiftDataMock: \(error)")
             return []
         }
     }
 }
