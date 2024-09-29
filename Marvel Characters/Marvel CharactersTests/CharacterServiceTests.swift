//
//  CharacterServiceTests.swift
//  Marvel CharactersTests
//
//  Created by Barbara Argolo on 26/09/24.
//

import XCTest
@testable import Marvel_Characters

final class CharacterServiceTests: XCTestCase {
    
    var mockURL: MockURLSession!
    var service: CharacterService!
    
    override func setUp()  {
        super.setUp()
        mockURL = MockURLSession()
        service = CharacterService(session: mockURL)
    }
    
    override func tearDown() {
        mockURL = nil
        service = nil
        
        super.tearDown()
    }
    
    
    func testFetchMarvelCorrectURL() {
        // given
        let expectedPublicKey = "fccb36a6244ade40e0ec6d71c80334bc"
        let expectedPrivateKey = "7fbca8f4deadd4e9bfca04ee4bfbdc102e555cd2"
        
        // when
        service.fetchMarvelCharacters { _ in }
        
        // then
        XCTAssertNotNil(mockURL.url)
        XCTAssertEqual(mockURL.url?.host(), "gateway.marvel.com")
        XCTAssertEqual(mockURL.url?.path(), "/v1/public/characters")
        
        let queryItems = URLComponents(url: mockURL.url!, resolvingAgainstBaseURL: false)?.queryItems
        XCTAssertNotNil(queryItems, "Query should not be nil")
        
        let queryDict = Dictionary(uniqueKeysWithValues: queryItems!.compactMap { item in
            (item.name, item.value)
        })
        
        XCTAssertEqual(queryDict["apikey"], expectedPublicKey, "API key should match the expected value")
        
        XCTAssertEqual(queryDict["limit"], "100", "Limit should be 100")
    }
}
