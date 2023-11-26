//
//  AppRegistry.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/18.
//

import SwiftUI

@MainActor
extension View {
  func withAppRouter() -> some View {
    navigationDestination(for: RouterDestination.self) { destination in
      switch destination {
      case let .bookDetail(book):
        BookDetailView(book: book)
      case let .genreDetail(genre):
        GenreDetailView(genre: genre)
      }
    }
  }
  
  func withSheetDestinations(sheetDestinations: Binding<SheetDestination?>) -> some View {
    sheet(item: sheetDestinations) { destination in
      switch destination {
      case .addNewBook:
        AddNewBookView()
      case .addNewGenre:
        AddNewGenre()
          .presentationDetents([.fraction(0.3)])
          .interactiveDismissDisabled()
      case .createCategory:
        CreateCategoryView()
      }
    }
  }
}
