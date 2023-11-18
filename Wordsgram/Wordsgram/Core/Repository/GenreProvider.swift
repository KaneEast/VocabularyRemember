//
//  GenreProvider.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/19.
//

import SwiftData
import SwiftUI

class GenreProvider: ObservableObject, DataProvidable {
  typealias T = Genre
  
  var allItems = [T]()
  private var context: ModelContext
  
  init(context: ModelContext) {
    self.context = context
    do {
      self.allItems = try fetchItems()
    } catch {
      self.allItems = [] // 如果出现错误，设置为空数组
    }
  }
  
  func fetchItems() throws -> [Genre] {
    let items = try context.fetch(FetchDescriptor<Genre>())
    return items
  }
  
  func set(item: Genre) throws {
    context.insert(item)
    try context.save()
  }
}
