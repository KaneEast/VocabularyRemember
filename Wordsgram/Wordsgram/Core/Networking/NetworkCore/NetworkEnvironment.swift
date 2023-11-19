//
//  NetworkEnvironment.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/17.
//

import Foundation
enum NetworkEnvironment {
  case development
  case staging
  case production
  case googlebook
  
  var baseURL: URL {
    switch self {
    case .development:
      URL(string: "http://192.168.2.101:8080/api")!
    case .staging:
      URL(string: "http://192.168.2.101:8080/api")!
    case .production:
      URL(string: "http://192.168.2.101:8080/api")!
    case .googlebook:
      URL(string: "https://www.googleapis.com/books/v1")!
    }
  }
}
