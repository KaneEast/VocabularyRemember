//
//  BookListView.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/14.
//

import SwiftUI
import SwiftData

@MainActor
struct BookListView: View {
  @State private var routerPath = RouterPath()
  @EnvironmentObject var bookProvider: BookProvider
  
  var body: some View {
    NavigationStack(path: $routerPath.path) {
      subview1
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            Button {
              routerPath.presentedSheet = .addNewBook
            } label: {
              Image(systemName: "plus.circle")
            }
          }
          ToolbarItem(placement: .topBarTrailing) {
            Menu {
              ForEach(SortingOption.allCases) { sortOption in
                Button(sortOption.title) {
                  bookProvider.bookSortOption = sortOption
                }
              }
            } label: {
              Image(systemName: "line.3.horizontal.decrease.circle")
            }
          }
        }
        .navigationTitle("Books")
        .searchable(text: $bookProvider.searchTerm, prompt: "Search book title")
        .withAppRouter()
        .withSheetDestinations(sheetDestinations: $routerPath.presentedSheet)
    }
  }
  
  @ViewBuilder
  private var subview1: some View {
    if !bookProvider.filteredBooks.isEmpty {
      List {
        ForEach(bookProvider.filteredBooks) { book in
          NavigationLink(value: RouterDestination.bookDetail(book: book)) {
            BookCellView(book: book)
          }
        }
        .onDelete {
          delete(indexSet: $0)
        }
      }
      .listStyle(PlainListStyle())
    }
    else if bookProvider.searchTerm.isEmpty {
      ContentUnavailableView("No Books, yet", systemImage: "square.stack.3d.up.slash.fill")
    } else {
      ContentUnavailableView.search(text: bookProvider.searchTerm)
    }
  }
  
  //  var subview: some View {
  //    if !bookProvider.filteredBooks.isEmpty {
  //      List {
  //        ForEach(bookProvider.filteredBooks) { book in
  //          NavigationLink(value: RouterDestination.bookDetail(book: book)) {
  //            BookCellView(book: book)
  //          }
  //        }
  //        .onDelete(perform: delete(indexSet:))
  //      }
  //      .listStyle(PlainListStyle())
  //    } else if bookProvider.searchTerm.isEmpty {
  //      ContentUnavailableView("No Books, yet", systemImage: "square.stack.3d.up.slash.fill")
  //    } else {
  //      ContentUnavailableView.search(text: bookProvider.searchTerm)
  //    }
  //  }
  
  @MainActor
  private func delete(indexSet: IndexSet) {
    bookProvider.deleteFromFiltered(indexSet: indexSet)
  }
}

#Preview {
  BookListView()
}
