//
//  GenreListView.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/14.
//

import Foundation
import SwiftUI
import SwiftData

@MainActor
struct GenreListView: View {
  @Environment(\.modelContext) private var context
  @Query(sort: \Genre.name) private var genres: [Genre]
  @State private var sortOption: GenreSortOrder = .forward
  @State private var routerPath = RouterPath()
  
  var body: some View {
    NavigationStack(path: $routerPath.path) {
      GenreListSubview(sortOrder: sortOption)
        .listStyle(PlainListStyle())
        .navigationTitle("Genres")
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            Button{ routerPath.presentedSheet = .addNewGenre } label: {
              Image(systemName: "plus.circle")
            }
          }
          ToolbarItem(placement: .topBarTrailing) {
            Button{
              sortOption = sortOption == .forward ? .reverse : .forward
            } label: {
              Image(systemName: "arrow.up.and.down.circle")
            }
          }
        }
        .withAppRouter()
        .withSheetDestinations(sheetDestinations: $routerPath.presentedSheet)
    }
  }
}

#Preview {
  GenreListView()
}
