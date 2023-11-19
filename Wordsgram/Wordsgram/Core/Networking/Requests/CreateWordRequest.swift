//
//  CreateWordRequest.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/17.
//

import Alamofire
import Foundation

struct CreateWordRequest: APIRequest {
  typealias Response = WordResponse
  typealias ParametersType = CreateWordParam
  
  var environment: NetworkEnvironment { .production }
  var path: String { "/words" }
  var method: HTTPMethod { .post }
  var parameters: Encodable? = nil
  let encoding: ParameterEncoding = JSONEncoding.default
  var headers: HTTPHeaders? = ["Authorization": "Bearer \(AuthService.shared.token ?? "")"]
  
  init(_ parameter: CreateWordParam) {
    self.parameters = parameter
  }
}

struct CreateWordParam: Encodable {
  var name: String
  var meaning: String
}

