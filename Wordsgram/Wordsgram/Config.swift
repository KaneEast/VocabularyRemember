//
//  Config.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/15.
//

import Foundation

enum Config {
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
}
