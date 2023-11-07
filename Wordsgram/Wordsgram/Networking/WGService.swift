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
}

struct UserCreateparam: Encodable {
    let name: String
    let username: String
    let password: String
}

// MARK: - TargetType Protocol Implementation
extension WGService: TargetType {
//    var baseURL: URL { URL(string: "http://localhost:8080/api")! }
    var baseURL: URL { URL(string: "http://192.168.2.101:8080/api")! }
    var path: String {
        switch self {
        case .createUser(_, _, _):
            return "/users"
        }
    }
    var method: Moya.Method {
        switch self {
        case .createUser:
            return .post
        }
    }
    var task: Task {
        switch self {
        case let .createUser(name, username, password): // Always send parameters as JSON in request body
            return .requestJSONEncodable(UserCreateparam(name: name, username: username, password: password))
        }
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}

// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    var utf8Encoded: Data { Data(self.utf8) }
}
