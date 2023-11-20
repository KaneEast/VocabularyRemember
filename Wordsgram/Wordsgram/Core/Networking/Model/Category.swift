//
//  Category.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/03.
//

import Foundation

final class Category: Codable, Hashable {
  static func == (lhs: Category, rhs: Category) -> Bool {
    lhs.id == rhs.id
  }
  
  var id: UUID?
  var name: String
  
  init(name: String) {
    self.name = name
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
