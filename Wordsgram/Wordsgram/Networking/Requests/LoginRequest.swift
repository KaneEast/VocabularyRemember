//
//  LoginRequest.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/17.
//

import Foundation
import Alamofire

struct LoginRequest: APIRequest {
  typealias Response = Token
  typealias ParametersType = LoginParam
  
  let environment: NetworkEnvironment = .production
  let path: String = "/users/login"
  let method: HTTPMethod = .post
  var parameters: Encodable?
  let encoding: ParameterEncoding = URLEncoding.default
  var headers: HTTPHeaders? = []
  
  init(_ parameter: LoginParam) {
    self.parameters = nil
    guard let loginString = "\(parameter.username):\(parameter.password)".data(using: .utf8)?.base64EncodedString() else {
      fatalError("Failed to encode credentials") // TODO: Should no fatal Error
    }
    headers =  ["Authorization": "Basic \(loginString)"]
  }
}

struct LoginParam: Encodable {
  var username: String
  var password: String
}

