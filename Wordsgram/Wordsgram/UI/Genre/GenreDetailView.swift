//
//  GenreDetailView.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/14.
//

import SwiftUI
import SwiftData

struct GenreDetailView: View {
  let genre: Genre
  
  var body: some View {
    VStack {
      Group {
        if genre.books.isEmpty {
          ContentUnavailableView(
            "No data",
            systemImage: "square.stack.3d.up.slash"
          )
        } else {
          List(genre.books) { book in
            Text(book.title)
          }
        }
      }
      .navigationTitle(genre.name)
    }
  }
}

//#Preview {
//  GenreDetailView(genre: Genre(name: "Fiction"))
//    .withModelContainer()
//}
