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
    
    func login(username: String, password: String) async throws {
        let token: Token = try await  WGProviderFactory.shared.requestPublisher(.login(username: username, password: password))
            .filterSuccessfulStatusCodes()
            .map(Token.self)
            .asyncValue()
        
        await MainActor.run {
            self.token = token.value
        }
    }
    
    func register(name: String, username: String, password: String) async  throws {
        try await WGProviderFactory.shared.requestPublisher(.createUser(name: name, username: username, password: password))
            .filterSuccessfulStatusCodes()
            .asyncValue()
        
//        await MainActor.run {
//            self.token = token.value
//        }
//        
//        
//        
//        let provider = MoyaProvider<WGService>()
//        provider.request(.createUser(name: name, username: username, password: password)) { result in
//            // do something with the result (read on for more details)
//            switch result {
//            case let .success(moyaResponse):
//                let data = moyaResponse.data // Data, your JSON response is probably in here!
//                let statusCode = moyaResponse.statusCode // Int - 200, 401, 500, etc
//                
//                print("Register Successed, Please Login")
//                
//                // do something in your app
//            case let .failure(error):
//                print(error.localizedDescription)
//                DispatchQueue.main.async {
//                    self.requestError = true
//                }
//            }
//        }
    }
}
