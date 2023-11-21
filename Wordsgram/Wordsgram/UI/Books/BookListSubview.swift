//
//  BookListSubview.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/20.
//

import SwiftUI
import SwiftData

struct BookListSubview: View {
  @EnvironmentObject private var coordinator: BookCoordinator
  @Query private var books: [Book]
  var searchTerm: String
  
  init(searchTerm: String = "", bookSortOption: BookSortingOption) {
    self.searchTerm = searchTerm
    if searchTerm.isEmpty {
      _books = Query(sort: [bookSortOption.sortOption])
    } else {
      _books = Query(filter: #Predicate { $0.title.localizedStandardContains(searchTerm)}, sort: [bookSortOption.sortOption])
    }
  }
  
  var body: some View {
    if !books.isEmpty {
      List {
        ForEach(books) { book in
          NavigationLink(value: RouterDestination.bookDetail(book: book)) {
            BookCellView(title: book.title,
                         author: book.author,
                         cover: book.cover,
                         publishedYear: book.publishedYear)
          }
        }
        .onDelete {
          delete(indexSet: $0)
        }
      }
      .listStyle(PlainListStyle())
    }
    else if searchTerm.isEmpty {
      ContentUnavailableView("No Books, yet", systemImage: "square.stack.3d.up.slash.fill")
    } else {
      ContentUnavailableView.search(text: searchTerm)
    }
  }
  
  @MainActor
  private func delete(indexSet: IndexSet) {
    var bookToDelete = [Book]()
    for index in indexSet {
      bookToDelete.append(books[index])
    }
    try? coordinator.deldete(books: bookToDelete)
  }
}

#Preview {
  BookListSubview(bookSortOption: BookSortingOption.none)
    .environmentObject(BookCoordinator(bookClient: BookClient(), bookRepository: ModelRepository<Book>(context: SystemServices.previewModelContainer.mainContext)))
}
