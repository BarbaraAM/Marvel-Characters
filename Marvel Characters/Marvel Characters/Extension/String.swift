//
//  String.swift
//  Marvel Characters
//
//  Created by Barbara Argolo on 26/09/24.
//

import CryptoKit

extension String {
    func md5() -> String {
        let digest = Insecure.MD5.hash(data: self.data(using: .utf8)!)
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }
}
