//
//  BookService.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/16.
//

import SwiftUI
import Combine

class BookService: ObservableObject {
  var cancellables = Set<AnyCancellable>()
  
  func searchBook(title: String, author: String) async throws -> BookSearchResponse {
    try await BookSearchRequest(title: title, author: author).request().asyncValue(storeIn: &cancellables)
  }
}
