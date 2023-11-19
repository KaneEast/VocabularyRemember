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
      BookListSubview()
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
}

#Preview {
  BookListView()
}
