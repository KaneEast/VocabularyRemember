//
//  UserDefaultsHelper.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/15.
//

import Foundation

enum UserDefaultsHelper {
  static private let defaults = UserDefaults(
    suiteName: Configuration.stringValue(forKey: "USER_DEFAULTS_SUITE_NAME"))
  ?? .standard
  
  static private let recordsKey = Configuration.stringValue(forKey: "USER_DEFAULTS_RECORDS_KEY")
  
  
  // TODO: Access the Database
  //    static func getRecords() -> [Word] {
  //        guard
  //            let objects = defaults.value(forKey: recordsKey) as? Data,
  //            let hatchlings = try? JSONDecoder().decode([Word].self, from: objects)
  //        else {
  //            return []
  //        }
  //
  //        return hatchlings
  //    }
  //
  //    // TODO: Access the Database
  //    static func persistRecords(_ array: [Word]) {
  //      let encoder = JSONEncoder()
  //      if let encoded = try? encoder.encode(array) {
  //        defaults.set(encoded, forKey: recordsKey)
  //      }
  //    }
  static func getRecords() -> Int {
    guard
      let objects = defaults.value(forKey: recordsKey) as? Data,
      let hatchlings = try? JSONDecoder().decode(Int.self, from: objects)
    else {
      return 0
    }
    
    return hatchlings
  }
  
  // TODO: Access the Database
  static func persistRecords(_ number: Int) {
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(number) {
      defaults.set(encoded, forKey: recordsKey)
    }
  }
  
  
  static func getRecordsCount() -> Int {
    //        return getRecords().count
    return getRecords()
  }
}
