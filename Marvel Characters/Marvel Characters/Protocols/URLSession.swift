//
//  URLSession.swift
//  Marvel Characters
//
//  Created by Barbara Argolo on 26/09/24.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with url: URL, completion: @escaping (Data? , URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}


protocol URLSessionDataTaskProtocol {
    func resume()
}


extension URLSession: URLSessionProtocol {
    func dataTask(with url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        let task: URLSessionDataTask = self.dataTask(with: url, completionHandler: completion)
        return task
    }
    
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

