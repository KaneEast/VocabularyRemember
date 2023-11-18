//
//  APIRequest.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/17.
//

import Foundation
import Alamofire
import Combine

protocol APIRequest: NetworkRouter {
  associatedtype Response: Decodable
}

extension APIRequest {
  func request() -> AnyPublisher<Response, Error> {
    do {
      let request = try asURLRequest()
      return NetworkSessionManager.shared.alamofireSession
        .request(request)
        .validate() // Validate HTTP response status codes
        .responseString { response in
          // Print the response string for debugging
          print("Response String: \(response)")
        }
        .publishDecodable(type: Response.self)
        .tryMap { result in
          guard let response = result.value else {
            throw result.error ?? URLError(.badServerResponse)
          }
          return response
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    } catch {
      return Fail(error: error).eraseToAnyPublisher()
    }
  }
}

struct SuccessResponse: Decodable {
  // You can include standard fields that might be common in successful responses.
  // Since your current response has no content, this struct remains empty for now.
  // It's ready to be extended in the future if your API starts returning data on successful operations.
}

extension APIRequest where Response == SuccessResponse {
  func request() -> AnyPublisher<Response, Error> {
    do {
      let request = try asURLRequest()
      return NetworkSessionManager.shared.alamofireSession
        .request(request)
        .validate(statusCode: 200..<300) // Validates HTTP status code for the successful range
        .responseString { response in
          // Print the response string for debugging
          print("Response String: \(response)")
        }
        .publishData(emptyResponseCodes: [201]) // Handles empty response for 201 status code
        .tryMap { result in
          guard let response = result.response else {
            throw AFError.responseValidationFailed(reason: .dataFileNil)
          }
          if response.statusCode == 201 {
            // Return empty SuccessResponse for 201 status code
            return SuccessResponse()
          } else {
            // Decode response for other status codes
            return try JSONDecoder().decode(SuccessResponse.self, from: result.data ?? Data())
          }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    } catch {
      return Fail(error: error).eraseToAnyPublisher()
    }
  }
}

