//
//  WGService.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/08.
//

import Foundation
import Moya

enum WGService {
    case createUser(name: String, username: String, password: String)
    case login(username: String, password: String)
    case requestWords
    case requestUsers
    case requestCategories
}

// MARK: - TargetType Protocol Implementation
extension WGService: TargetType {
//    var baseURL: URL { URL(string: "http://localhost:8080/api")! }
    var baseURL: URL { URL(string: "http://192.168.2.101:8080/api")! }
    var path: String {
        switch self {
        case .createUser:
            return "/users"
        case .login:
            return "/users/login"
        case .requestWords:
            return "/words"
        case .requestUsers:
            return "/users"
        
        case .requestCategories:
            return "/categories"
        }
    }
    var method: Moya.Method {
        switch self {
        case .createUser:
            return .post
        case .login:
            return .post
        case .requestWords:
            return .get
        case .requestUsers:
            return .get
        case .requestCategories:
            return .get
        }
    }
    var task: Task {
        switch self {
        case let .createUser(name, username, password): // Always send parameters as JSON in request body
            return .requestJSONEncodable(UserCreateparam(name: name, username: username, password: password))
        case .login:
            return .requestPlain
        case .requestWords, .requestUsers:
            return .requestPlain // Send no parameters
        case .requestCategories:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case let .login(username, password):
            guard let loginString = "\(username):\(password)".data(using: .utf8)?.base64EncodedString() else {
                fatalError("Failed to encode credentials") // TODO: Should no fatal Error
            }
            return [
                "Authorization": "Basic \(loginString)",
                "Content-type": "application/json"
            ]
        default:
            return ["Content-type": "application/json"]
        }
        
    }
}

// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    var utf8Encoded: Data { Data(self.utf8) }
}
