//
//  Config.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/15.
//

import Foundation

enum Configuration {
    enum Error: Swift.Error {
      case missingKey, invalidValue
    }
    
    /// stringValue(forKey:) is a helper method that simplifies retrieving values from Info.plist. It calls Bundle‘s object(forInfoDictionaryKey:) to obtain a string value.
    ///
    /// Note: You can store and obtain other data types from property lists, like Booleans and arrays.
    /// For simplicity, because NinjaCounter only needs string values, this helper method is for strings only.
    static func stringValue(forKey key: String) -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String
        else {
            fatalError("Invalid value or undefined key")
        }
        return value
    }
    
    static let googlebook_apikey = "AIzaSyD6HIRAMsM7jI3p4rVYQ03DjXLlYlNzJGs"
    
    static var appToken: String {
        // swiftlint:disable:next force_try
        try! value(for: "APP_TOKEN")
    }
    
    static func value<T>(for key: String) throws -> T where T: LosslessStringConvertible {
      guard let object = Bundle.main.object(forInfoDictionaryKey: key) else {
        throw Error.missingKey
      }
      
      switch object {
      case let value as T:
        return value
      case let string as String:
        guard let value = T(string) else { throw Error.invalidValue }
        return value
      default:
        throw Error.invalidValue
      }
    }
}
