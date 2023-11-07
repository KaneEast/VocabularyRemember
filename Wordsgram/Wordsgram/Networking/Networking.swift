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

enum AuthResult {
    case success
    case failure
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
    
    func logout() {
        token = nil
    }
    
    func login(username: String, password: String, completion: @escaping (AuthResult) -> Void) {
//        let path = "http://localhost:8080/api/users/login"
        let path = "http://192.168.2.101:8080/api/users/login"
        
        guard let url = URL(string: path) else {
            fatalError("Failed to convert URL")
        }
        guard let loginString = "\(username):\(password)".data(using: .utf8)?.base64EncodedString() else {
            fatalError("Failed to encode credentials")
        }
//        let loginString = "\(username):\(password)"
        
        var loginRequest = URLRequest(url: url)
        loginRequest.addValue("Basic \(loginString)", forHTTPHeaderField: "Authorization")
        loginRequest.httpMethod = "POST"
        
        let dataTask = URLSession.shared.dataTask(with: loginRequest) { data, response, _ in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let jsonData = data else {
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
    
    func update(
        with updateData: CreateWordData,
        auth: Auth,
        completion: @escaping (Result<Word, ResourceRequestError>) -> Void
    ) {
        do {
            guard let token = auth.token else {
                auth.logout()
                return
            }
            var urlRequest = URLRequest(url: resource)
            urlRequest.httpMethod = "PUT"
            urlRequest.httpBody = try JSONEncoder().encode(updateData)
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(.noData))
                    return
                }
                guard
                    httpResponse.statusCode == 200,
                    let jsonData = data
                else {
                    if httpResponse.statusCode == 401 {
                        auth.logout()
                    }
                    completion(.failure(.noData))
                    return
                }
                do {
                    let acronym = try JSONDecoder().decode(Word.self, from: jsonData)
                    completion(.success(acronym))
                } catch {
                    completion(.failure(.decodingError))
                }
            }
            dataTask.resume()
        } catch {
            completion(.failure(.encodingError))
        }
    }
    
    func remove(
        category: Category,
        auth: Auth,
        completion: @escaping (Result<Void, CategoryAddError>) -> Void
    ) {
        guard let categoryID = category.id else {
            completion(.failure(.noID))
            return
        }
        guard let token = auth.token else {
            auth.logout()
            return
        }
        let url = resource
            .appendingPathComponent("categories")
            .appendingPathComponent("\(categoryID)")
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let dataTask = URLSession.shared
            .dataTask(with: urlRequest) { _, response, _ in
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(.invalidResponse))
                    return
                }
                guard httpResponse.statusCode == 204 else {
                    if httpResponse.statusCode == 401 {
                        auth.logout()
                    }
                    completion(.failure(.invalidResponse))
                    return
                }
                completion(.success(()))
            }
        dataTask.resume()
    }
    
    func delete(auth: Auth) {
        guard let token = auth.token else {
            auth.logout()
            return
        }
        var urlRequest = URLRequest(url: resource)
        urlRequest.httpMethod = "DELETE"
        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let dataTask = URLSession.shared.dataTask(with: urlRequest)
        dataTask.resume()
    }
    
    func getUser(completion: @escaping (Result<User, ResourceRequestError>) -> Void) {
        let url = resource.appendingPathComponent("user")
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noData))
                return
            }
            do {
                let decoder = JSONDecoder()
                let user = try decoder.decode(User.self, from: jsonData)
                completion(.success(user))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        dataTask.resume()
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
            auth.logout()
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
                    auth.logout()
                }
                completion(.failure(.invalidResponse))
                return
            }
            completion(.success(()))
        }
        dataTask.resume()
    }
}
