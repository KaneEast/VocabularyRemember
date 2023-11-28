//
//  GenreSelectionView.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/14.
//

import SwiftUI
import SwiftData

struct GenreSelectionView: View {
  @Query(sort: \Genre.name) private var genres: [Genre]
  @Binding var selectedGenres: Set<Genre>
  
  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        ForEach(genres) { genre in
          HStack {
            Text(genre.name)
            Spacer()
            Image(systemName: selectedGenres.contains(genre) ? "checkmark.circle.fill" : "circle.dashed")
          }
          .contentShape(Rectangle())
          .onTapGesture {
            if !selectedGenres.contains(genre) {
              selectedGenres.insert(genre)
            } else {
              selectedGenres.remove(genre)
            }
          }
        }
      }
      .cornerRadius(10)
    }
    .padding()
    .background(.ultraThinMaterial)
  }
}

#Preview {
  GenreSelectionView(selectedGenres: .constant([]))
}
