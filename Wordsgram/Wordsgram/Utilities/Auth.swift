//
//  Auth.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/03.
//

import Foundation
import SwiftKeychainWrapper

enum AuthResult {
    case success
    case failure
}

class Auth: ObservableObject {
    static let keychainKey = "TIL-API-KEY"
    
    static let shared: Auth = Auth()
    
    @Published
    private(set) var isLoggedIn = false
    
    init() {
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
    
    func logout() {
        token = nil
    }
    
    func login(username: String, password: String, completion: @escaping (AuthResult) -> Void) {
        let path = "http://localhost:8080/api/users/login"
        guard let url = URL(string: path) else {
            fatalError("Failed to convert URL")
        }
        guard let loginString = "\(username):\(password)"
            .data(using: .utf8)?
            .base64EncodedString()
        else {
            fatalError("Failed to encode credentials")
        }
        
        var loginRequest = URLRequest(url: url)
        loginRequest.addValue("Basic \(loginString)", forHTTPHeaderField: "Authorization")
        loginRequest.httpMethod = "POST"
        
        let dataTask = URLSession.shared.dataTask(with: loginRequest) { data, response, _ in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                  let jsonData = data else {
                completion(.failure)
                return
            }
            do {
                let token = try JSONDecoder().decode(Token.self, from: jsonData)
                self.token = token.value
                completion(.success)
            } catch {
                completion(.failure)
            }
        }
        dataTask.resume()
    }
}


//class Auth: ObservableObject {
//
//    struct Credentials {
//        var accessToken: String?
//        var refreshToken: String?
//    }
//
//    enum KeychainKey: String {
//        case accessToken
//        case refreshToken
//    }
//
//    static let shared: Auth = Auth()
//    private let keychain: KeychainWrapper = KeychainWrapper.standard
//
//    @Published var loggedIn: Bool = false
//
//    private init() {
//        loggedIn = true//hasAccessToken()
//    }
//
//    func getCredentials() -> Credentials {
//        return Credentials(
//            accessToken: keychain.string(forKey: KeychainKey.accessToken.rawValue),
//            refreshToken: keychain.string(forKey: KeychainKey.refreshToken.rawValue)
//        )
//    }
//
//    func setCredentials(accessToken: String, refreshToken: String) {
//        keychain.set(accessToken, forKey: KeychainKey.accessToken.rawValue)
//        keychain.set(refreshToken, forKey: KeychainKey.refreshToken.rawValue)
//
//        loggedIn = true
//    }
//
//    func hasAccessToken() -> Bool {
//        return getCredentials().accessToken != nil
//    }
//
//    func getAccessToken() -> String? {
//        return getCredentials().accessToken
//    }
//
//    func getRefreshToken() -> String? {
//        return getCredentials().refreshToken
//    }
//
//    func logout() {
//        KeychainWrapper.standard.removeObject(forKey: KeychainKey.accessToken.rawValue)
//        KeychainWrapper.standard.removeObject(forKey: KeychainKey.refreshToken.rawValue)
//
//        loggedIn = false
//    }
//}
