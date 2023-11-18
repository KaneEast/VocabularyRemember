//
//  GetCategoryOfWordRequest.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/17.
//

import Alamofire
import Foundation
struct GetCategoryOfWordRequest: APIRequest {
    typealias Response = [Category] // Replace with your actual response model

    var environment: NetworkEnvironment { .production }
    var path: String { "/words/\(wordID)/categories" }
    var method: HTTPMethod { .get }
    var parameters: Encodable? { nil }
    var headers: HTTPHeaders?
    var encoding: ParameterEncoding { URLEncoding.default }

    let wordID: String
}
