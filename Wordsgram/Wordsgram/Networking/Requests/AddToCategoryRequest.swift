//
//  AddToCategoryRequest.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/17.
//

import Alamofire
import Foundation

struct AddToCategoryRequest: APIRequest {
  typealias Response = SuccessResponse // Replace with your actual response model
  
  var environment: NetworkEnvironment { .production }
  var path: String { "/words/\(wordID)/categories/\(categoryID)" }
  var method: HTTPMethod { .post }
  var parameters: Encodable? { nil }
  var headers: HTTPHeaders? = ["Authorization": "Bearer \(AuthService.shared.token ?? "")"]
  var encoding: ParameterEncoding { JSONEncoding.default }
  
  let wordID: String
  let categoryID: String
}
