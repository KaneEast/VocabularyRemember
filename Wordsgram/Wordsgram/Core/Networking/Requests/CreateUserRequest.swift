//
//  CreateUserRequest.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/17.
//

import Foundation
import Alamofire

struct CreateUserRequest: APIRequest {
    typealias Response = UserResponse // Replace with your actual response model
    typealias ParametersType = CreateUserParam

    var environment: NetworkEnvironment { .production }
    var path: String { "/users" }
    var method: HTTPMethod { .post }
    var parameters: Encodable? = nil
    let encoding: ParameterEncoding = JSONEncoding.default
    var headers: HTTPHeaders?

    init(_ parameter: CreateUserParam) {
        self.parameters = parameter
    }
}

struct CreateUserParam: Encodable {
    var name: String
    var username: String
    var password: String
}
