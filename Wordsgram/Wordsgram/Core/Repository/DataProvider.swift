//
//  DataProvider.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/19.
//

import SwiftData
import SwiftUI

protocol DataProvidable: AnyObject {
  associatedtype T: PersistentModel
  var allItems: [T] { get }
  func fetchItems() throws -> [T]
  func set(item: T) throws 
}