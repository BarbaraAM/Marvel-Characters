//
//  CharactersSwiftData.swift
//  Marvel CharactersTests
//
//  Created by Barbara Argolo on 28/09/24.
//

import XCTest
@testable import Marvel_Characters


final class CharactersSwiftData: XCTestCase {
    var mockSwiftData: SwiftDataMock!
        
        override func setUp() {
            super.setUp()
            mockSwiftData = SwiftDataMock()
        }
        
        override func tearDown() {
            mockSwiftData = nil
            super.tearDown()
        }
        
        func testSavingCharacter() {
            //given
            let mockCharacter = MarvelCharacterStorage(
                id: 101,
                name: "Mock Character",
                characterDescription: "Test Description",
                resourceURI: "http://mock.url",
                urls: nil,
                thumbnail: nil,
                comics: nil,
                stories: nil,
                events: nil,
                series: nil
            )
            
            //when
            mockSwiftData.saveCharacterToStorage(mockCharacter)
            
            //then
            let fetchedCharacters = mockSwiftData.fetchCharacters()
            XCTAssertEqual(fetchedCharacters.count, 1, "Character should be saved in SwiftDataMock")
            XCTAssertEqual(fetchedCharacters.first?.name, "Mock Character", "Saved character's name should match")
        }
        
        func testFetchingCharacters() {
            
            //given
            let mockCharacter1 = MarvelCharacterStorage(id: 101, name: "Mock Character 1", characterDescription: "Descrip 1", resourceURI: "http://mock1.url", urls: nil, thumbnail: nil, comics: nil, stories: nil, events: nil, series: nil)
            let mockCharacter2 = MarvelCharacterStorage(id: 102, name: "Mock Character 2", characterDescription: "Descrip 2", resourceURI: "http://mock2.url", urls: nil, thumbnail: nil, comics: nil, stories: nil, events: nil, series: nil)
            
            mockSwiftData.saveCharacterToStorage(mockCharacter1)
            mockSwiftData.saveCharacterToStorage(mockCharacter2)
            
            //when
            let fetchedCharacters = mockSwiftData.fetchCharacters()
            
            //then
            XCTAssertEqual(fetchedCharacters.count, 2, "There should be 2 characters in SwiftDataMock")
        }
        
        func testDeletingCharacter() {
            //given
            let mockCharacter = MarvelCharacterStorage(id: 103, name: "character to delete", characterDescription: "To be deleted", resourceURI: "http://delete.url", urls: nil, thumbnail: nil, comics: nil, stories: nil, events: nil, series: nil)
            
            mockSwiftData.saveCharacterToStorage(mockCharacter)
            
            //when
            mockSwiftData.deleteCharacter(byId: 103)
            
            //then
            let fetchedCharacters = mockSwiftData.fetchCharacters()
            XCTAssertEqual(fetchedCharacters.count, 0, "Character should be deleted from SwiftDataMock")
        }
}
