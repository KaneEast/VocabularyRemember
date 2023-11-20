//
//  MockBookProvider.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/19.
//

import SwiftData
import SwiftUI

class MockBookProvider: ObservableObject, DataProvidable {
  typealias T = Book
  
  var allItems: [Book] = [Book(title: "title", author: "author", publishedYear: 2023)]
  
  func fetchItems() throws -> [Book] {
    return allItems
  }
  
  func set(item: Book) throws {
    // 添加逻辑来模拟设置书籍的行为
  }
}
