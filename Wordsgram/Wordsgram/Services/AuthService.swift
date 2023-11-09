//
//  Networking.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/08.
//

import Foundation

class AuthService: ObservableObject {
    static let keychainKey = "WORDSGRAM-API-KEY"
    @Published private(set) var isLoggedIn = false
    static let shared = AuthService()
    
    private init() {
        if token != nil {
            self.isLoggedIn = true
        }
    }
    
    var token: String? {
        get {
            Keychain.load(key: AuthService.keychainKey)
        }
        set {
            if let newToken = newValue {
                Keychain.save(key: AuthService.keychainKey, data: newToken)
            } else {
                Keychain.delete(key: AuthService.keychainKey)
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
