//
//  RequestWordsRequest.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/17.
//

import Foundation
import Alamofire
struct RequestWordsRequest: APIRequest {
    typealias Response = [Word] // Replace with your actual response model

    var environment: NetworkEnvironment { .production }
    var path: String { "/words" }
    var method: HTTPMethod { .get }
    var parameters: Encodable? = nil
    let encoding: ParameterEncoding = URLEncoding.default
    var headers: HTTPHeaders?
}
