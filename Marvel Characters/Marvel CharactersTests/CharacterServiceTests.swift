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
        //given
        mockURL = MockURLSession()
        service = CharacterService(session: mockURL)
    }
    
    override func tearDown() {
        mockURL = nil
        service = nil
        
        super.tearDown()
    }
    
    func testFetchMarvelCorrectURL() {
        
        //when
        service.fetchMarvelCharacters { _ in }
        
        
        //then
        XCTAssertNotNil(mockURL.url)
        XCTAssertEqual(mockURL.url?.host(), "gateway.marvel.com")
        XCTAssertEqual(mockURL.url?.path(), "/v1/public/characters")
        
        let queryItems = URLComponents(url: mockURL.url!, resolvingAgainstBaseURL: false)?.queryItems
        
        XCTAssertNotNil(queryItems, "Query should not be nil")
        
        let queryDict = Dictionary(uniqueKeysWithValues: queryItems!.compactMap { item in
               (item.name, item.value)
           })
        if let apiKey = queryDict["apikey"] {
            XCTAssertEqual(apiKey, "fccb36a6244ade40e0ec6d71c80334bc", "API key should match the expected value")
        } else {
            XCTFail("API Key is missing. \(mockURL.url)")
        }
        XCTAssertNotNil(queryDict["ts"] as Any?)
        XCTAssertNotNil(queryDict["hash"] as Any?)
        XCTAssertEqual(queryDict["limit"], "100")
  
    }

}
