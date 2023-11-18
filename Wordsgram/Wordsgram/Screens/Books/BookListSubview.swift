//
//  BookListSubview.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/15.
//

import SwiftUI
import SwiftData

struct BookListSubview: View {
  @EnvironmentObject var bookProvider: BookProvider
  
  var body: some View {
    if !bookProvider.filteredBooks.isEmpty {
      List {
        ForEach(bookProvider.filteredBooks) { book in
          NavigationLink(value: RouterDestination.bookDetail(book: book)) {
            BookCellView(book: book)
          }
        }
        .onDelete(perform: delete(indexSet:))
      }
      .listStyle(PlainListStyle())
    } else if bookProvider.searchTerm.isEmpty {
      ContentUnavailableView("No Books, yet", systemImage: "square.stack.3d.up.slash.fill")
    } else {
      ContentUnavailableView.search(text: bookProvider.searchTerm)
    }
  }
  
  private func delete(indexSet: IndexSet) {
    bookProvider.deleteFromFiltered(indexSet: indexSet)
  }
}
