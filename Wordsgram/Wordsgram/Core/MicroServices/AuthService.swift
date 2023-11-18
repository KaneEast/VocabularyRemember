//
//  Networking.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/08.
//

import Foundation
import Combine

class AuthService: ObservableObject {
    static let keychainKey = "WORDSGRAM-API-KEY"
    @Published private(set) var isLoggedIn = false
    
    
    static let shared = AuthService()
    var cancellables = Set<AnyCancellable>()
    
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
    
    func login(username: String, password: String) async throws {
        let getUserRequest = LoginRequest(LoginParam(username: username, password: password))
        getUserRequest.request()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                }
            }, receiveValue: { token in
                print("token: \(token.value)")
                self.token = token.value
            })
            .store(in: &cancellables)
    }
    
    func register(name: String, username: String, password: String) async  throws {
        let createUserRequest = CreateUserRequest(CreateUserParam(name: name, username: username, password: password))
        createUserRequest.request()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                }
            }, receiveValue: {_ in
                // TODO: Show Alert
            })
            .store(in: &cancellables)
    }
}
