//
//  Marvel_CharactersTests.swift
//  Marvel CharactersTests
//
//  Created by Barbara Argolo on 26/09/24.
//

import XCTest
@testable import Marvel_Characters

final class CharactersVMTests: XCTestCase {
    
    var mockService: MockCharacterService!
    var vm: ListViewModel!
    
    override func setUp()  {
        super.setUp()
         mockService = MockCharacterService()
         vm = ListViewModel(coordinator: nil, characterService: mockService)
    }
    
    //dealocate instances
    override func tearDown() {
        mockService = nil
        vm = nil
        
        super.tearDown()
    }

    
//    func testCharactersSuccess() {
//        
//        //given
//        let mockService = MockCharacterService()
//        let vm = CharacterVM(coordinator: nil, characterService: mockService)
//        
//        //when
//        vm.fetchCharacters()
//        
//        //then
//        XCTAssertEqual(vm.characters.count, 2, "Should load 2 characters.")
//        XCTAssertEqual(vm.characters[0].name, "Iron Man", "Iron Man it's the first character in the list.")
//        
//    }
//    
//    func testCharactersFailure() {
//        //given
//        let mockService = MockCharacterService()
//        mockService.shouldReturnError = true
//        let vm = CharacterVM(coordinator: nil, characterService: mockService)
//        
//        //when
//        vm.fetchCharacters()
//        
//        //then
//        XCTAssertTrue(vm.characters.isEmpty, "No Characters must load in error case.")
//
//    }

}
