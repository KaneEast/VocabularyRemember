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
  @State var routerPath = RouterManager.shared.bookTabRouter
  @State private var searchTerm: String = ""
  @State private var bookSortOption = BookSortingOption.none
  
  var body: some View {
    NavigationStack(path: $routerPath.path) {
      BookListSubview(searchTerm: searchTerm, bookSortOption: bookSortOption)
        .withAppRouter()
        .withSheetDestinations(sheetDestinations: $routerPath.presentedSheet)
        .navigationTitle("Books")
        .searchable(text: $searchTerm, prompt: "Search book title")
        .toolbar {
          ToolbarItemGroup {
            Button { routerPath.presentedSheet = .addNewBook } label: {
              Image(systemName: "plus.circle")
            }
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
    }
    .environment(routerPath)
  }
}

#Preview {
  BookListView()
    .environmentObject(BookCoordinator(bookClient: BookClient(),
                                       bookRepository: ModelRepository<Book>(context: ModelContainerManager.shared.previewModelContainer.mainContext)))
}
