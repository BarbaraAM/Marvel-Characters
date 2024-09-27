//
//  MockURLSession.swift
//  Marvel CharactersTests
//
//  Created by Barbara Argolo on 26/09/24.
//

import Foundation
@testable import Marvel_Characters

class MockURLSession: URLSessionProtocol {
    var url: URL?
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    
    func dataTask(with url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> Marvel_Characters.URLSessionDataTaskProtocol {
        self.url = url
        let mockData = MockURLSessionDataTask {
            completion(self.data, self.response, self.error)
        }
        return mockData
    }
   
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private let closure: () -> Void
    
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    func resume() {
        closure()
    }
}
