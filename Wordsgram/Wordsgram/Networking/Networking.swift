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
    static let keychainKey = "TIL-API-KEY"
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

// AcronymRequest
struct AcronymRequest {
    let resource: URL
    
    init(acronymID: UUID) {
        let resourceString = "http://localhost:8080/api/acronyms/\(acronymID)"
        guard let resourceURL = URL(string: resourceString) else {
            fatalError("Unable to createURL")
        }
        self.resource = resourceURL
    }
    
    func getCategories(completion: @escaping (Result<[Category], ResourceRequestError>) -> Void) {
        let url = resource.appendingPathComponent("categories")
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noData))
                return
            }
            do {
                let decoder = JSONDecoder()
                let categories = try decoder.decode([Category].self, from: jsonData)
                completion(.success(categories))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        dataTask.resume()
    }
    
    func add(category: Category, auth: Auth, completion: @escaping (Result<Void, CategoryAddError>) -> Void) {
        guard let token = auth.token else {
            auth.signOut()
            return
        }
        guard let categoryID = category.id else {
            completion(.failure(.noID))
            return
        }
        let url = resource.appendingPathComponent("categories").appendingPathComponent("\(categoryID)")
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { _, response, _ in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            guard httpResponse.statusCode == 201 else {
                if httpResponse.statusCode == 401 {
                    auth.signOut()
                }
                completion(.failure(.invalidResponse))
                return
            }
            completion(.success(()))
        }
        dataTask.resume()
    }
}
