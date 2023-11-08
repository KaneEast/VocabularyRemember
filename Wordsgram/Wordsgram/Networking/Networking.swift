//
//  Networking.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/08.
//

import Foundation

enum CategoryAddError: Error {
    case noID
    case invalidResponse
}

enum ResourceRequestError: Error {
    case noData
    case decodingError
    case encodingError
}


class Auth: ObservableObject {
    static let keychainKey = "WORDSGRAM-API-KEY"
    @Published private(set) var isLoggedIn = false
    static let shared = Auth()
    
    private init() {
        if token != nil {
            self.isLoggedIn = true
        }
    }
    
    var token: String? {
        get {
            Keychain.load(key: Auth.keychainKey)
        }
        set {
            if let newToken = newValue {
                Keychain.save(key: Auth.keychainKey, data: newToken)
            } else {
                Keychain.delete(key: Auth.keychainKey)
            }
            DispatchQueue.main.async {
                self.isLoggedIn = newValue != nil
            }
        }
    }
    
    func signOut() {
        token = nil
    }
}
