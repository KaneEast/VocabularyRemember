//
//  RequestCategoriesRequest.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/17.
//

import Alamofire
import Foundation
struct RequestCategoriesRequest: APIRequest {
    typealias Response = [Category] // Replace with your actual response model

    var environment: NetworkEnvironment { .production }
    var path: String { "/categories" }
    var method: HTTPMethod { .get }
    var parameters: Encodable? { nil }
    var headers: HTTPHeaders?
    var encoding: ParameterEncoding { URLEncoding.default }
}
