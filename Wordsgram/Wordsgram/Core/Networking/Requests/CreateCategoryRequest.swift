//
//  CreateCategoryRequest.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/17.
//

import Alamofire
import Foundation
struct CreateCategoryRequest: APIRequest {
    typealias Response = CategoryResponse // Replace with your actual response model

    var environment: NetworkEnvironment { .production }
    var path: String { "/categories" }
    var method: HTTPMethod { .post }
    var parameters: Encodable?
    var headers: HTTPHeaders? = ["Authorization": "Bearer \(AuthService.shared.token ?? "")"]
    var encoding: ParameterEncoding { JSONEncoding.default }
    
    init(_ parameter: CreateCategoryParam) {
        self.parameters = parameter
    }
}

struct CreateCategoryParam: Encodable {
    let name: String
}
