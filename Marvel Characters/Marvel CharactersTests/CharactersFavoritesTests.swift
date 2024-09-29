//
//  CharactersFavoritesTests.swift
//  Marvel CharactersTests
//
//  Created by Barbara Argolo on 29/09/24.
//

import XCTest
@testable import Marvel_Characters

final class CharactersFavoritesTests: XCTestCase {

    
    var viewModel: ListViewModel!
    var mockCharacterService: MockCharacterService!
    var swiftDataMock: SwiftDataMock!
    
    override func setUp() {
        super.setUp()
        mockCharacterService = MockCharacterService()
        swiftDataMock = SwiftDataMock()
        
        viewModel = ListViewModel(characterService: mockCharacterService, characterManager: swiftDataMock)
        
        let storageCharacter = MarvelCharacterStorage(
            id: 1011334,
            name: "3-D Man",
            characterDescription: "A superhero with unique abilities"
        )
        
        let sampleCharacter = MarvelCharacterDecoder(from: storageCharacter)
        
        viewModel.filteredCharacters = [sampleCharacter]
    }
    
    override func tearDown() {
        viewModel = nil
        mockCharacterService = nil
        swiftDataMock = nil
        super.tearDown()
    }
    
    func testFavoritingCharacter() {
        let character = viewModel.filteredCharacters.first!
        XCTAssertFalse(viewModel.isCharacterFavorited(character), "Character should not be favorited initially")
        
        viewModel.favoriteCharacter(by: character.id ?? 0)
        
        XCTAssertTrue(swiftDataMock.fetchCharacters().contains { $0.id == character.id }, "Character should be saved in SwiftDataMock after favoriting")
    }
    
    func testUnfavoritingCharacter() {

        let character = viewModel.filteredCharacters.first!
        swiftDataMock.saveCharacterToStorage(swiftDataMock.convertDecoderToStorage(for: character))
        XCTAssertTrue(swiftDataMock.fetchCharacters().contains { $0.id == character.id }, "Character should be in storage initially")

        viewModel.unfavoriteCharacter(by: character.id ?? 0)
        
        XCTAssertFalse(swiftDataMock.fetchCharacters().contains { $0.id == character.id }, "Character should be removed from SwiftDataMock after unfavoriting")
    }

}
