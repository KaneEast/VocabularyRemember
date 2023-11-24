//
//  BookSortingOption.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/15.
//

import Foundation

enum BookSortingOption: String, Identifiable, CaseIterable {
  
  var id: Self { return self }
  
  case title
  case author
  case publishedYear
  case none
  
  var title: String {
    switch self {
    case .title:
      "Title"
    case .author:
      "Author"
    case .publishedYear:
      "Published Year"
    case .none:
      "None"
    }
  }
  
  var sortOption: SortDescriptor<Book> {
    switch self {
    case .title:
      SortDescriptor(\Book.title, order: .forward)
    case .author:
      SortDescriptor(\Book.author, order: .forward)
    case .publishedYear:
      SortDescriptor(\Book.publishedYear, order: .forward)
    case .none:
      SortDescriptor(\Book.title)
    }
  }
}
