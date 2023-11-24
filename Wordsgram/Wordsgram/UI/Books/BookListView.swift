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
  @State private var searchTerm: String = ""
  @State private var bookSortOption = BookSortingOption.none
  
  var body: some View {
    NavigationStack(path: $routerPath.path) {
      BookListSubview(searchTerm: searchTerm, bookSortOption: bookSortOption)
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
              ForEach(BookSortingOption.allCases) { sortOption in
                Button(sortOption.title) {
                  bookSortOption = sortOption
                }
              }
            } label: {
              Image(systemName: "line.3.horizontal.decrease.circle")
            }
          }
        }
        .navigationTitle("Books")
        .searchable(text: $searchTerm, prompt: "Search book title")
        .withAppRouter()
        .withSheetDestinations(sheetDestinations: $routerPath.presentedSheet)
    }
  }
}

//#Preview {
//  BookListView()
//    .environmentObject(BookCoordinator(bookClient: BookClient(), bookRepository: ModelRepository<Book>(context: SystemServices.previewModelContainer.mainContext)))
//}
