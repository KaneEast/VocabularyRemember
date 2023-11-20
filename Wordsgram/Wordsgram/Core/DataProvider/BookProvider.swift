//
//  BookProvider.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/19.
//

import SwiftData
import SwiftUI

class BookProvider: ObservableObject, DataProvidable {
  typealias T = Book
  
  @Published var filteredBooks: [Book]
  @Published var bookSortOption = SortingOption.none {
    didSet {
      updateFilteredBooks()
    }
  }
  
  @Published var searchTerm: String = "" {
    didSet {
      updateFilteredBooks()
    }
  }
  
  @Published var allItems = [T]()
  private var context: ModelContext
  
  init(context: ModelContext) {
    self.context = context
    self.filteredBooks = []
    
    self.allItems = fetchItems()
    filteredBooks = allItems
  }
  
  func fetchItems() -> [Book] {
    let items = try? context.fetch(FetchDescriptor<Book>())
    self.allItems = items ?? []
    return items ?? []
  }
  
  func set(item: Book) throws {
    item.genres.forEach { genre in
      genre.books.append(item)
      context.insert(genre)
    }
    
    context.insert(item)
    try context.save()
    
    self.allItems = fetchItems()
    self.updateFilteredBooks()
  }
  
  func deleteFromFiltered(indexSet: IndexSet) {
    indexSet.forEach { index in
      let book = filteredBooks[index]
      context.delete(book)
      
      do {
        try context.save()
        self.allItems = fetchItems()
        self.updateFilteredBooks()
      } catch {
        print(error.localizedDescription)
      }
    }
  }
  
  private func updateFilteredBooks() {
    do {
      if searchTerm.isEmpty {
        let sortDescriptors = [bookSortOption.sortOption]
        filteredBooks = try context.fetch(FetchDescriptor<Book>(sortBy: sortDescriptors))
      } else {
        filteredBooks = allItems.filter {
          $0.title.localizedStandardContains(searchTerm)
        }
      }
    } catch {
      print("Error fetching books: \(error)")
      filteredBooks = []
    }
  }
}



