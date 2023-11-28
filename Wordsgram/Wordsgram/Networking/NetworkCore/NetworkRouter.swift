//
//  NetworkRouter.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/17.
//

import Foundation
import Alamofire

protocol NetworkRouter {
  var environment: NetworkEnvironment { get }
  var path: String { get }
  var method: HTTPMethod { get }
  var parameters: Encodable? { get }
  var headers: HTTPHeaders? { get }
  var encoding: ParameterEncoding { get }
  
  func asURLRequest() throws -> URLRequest
}

extension NetworkRouter {
  func asURLRequest() throws -> URLRequest {
    let url = environment.baseURL.appendingPathComponent(path)
    var request = URLRequest(url: url)
    request.method = method
    request.headers = NetworkSessionManager.shared.combinedHeaders(additionalHeaders: headers)
    
    if let parameters = parameters {
      request = try encoding.encode(request, with: parameters.asDictionary())
    }
    
    return request
  }
}

extension Encodable {
  func asDictionary() throws -> [String: Any] {
    let data = try JSONEncoder().encode(self)
    guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any] else {
      throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: AFError.explicitlyCancelled))
    }
    return dictionary
  }
}

