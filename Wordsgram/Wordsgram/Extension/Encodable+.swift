//
//  Encodable+.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/08.
//

import Foundation

extension Encodable {
  func toDictionary(keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy = .useDefaultKeys) -> [String: Any] {
    let jsonEncoder = JSONEncoder()
    jsonEncoder.keyEncodingStrategy = keyEncodingStrategy
    jsonEncoder.dateEncodingStrategy = .iso8601
    guard let data = try? jsonEncoder.encode(self) else {
      fatalError()
    }
    guard let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
      fatalError()
    }
    return dictionary
  }
}
