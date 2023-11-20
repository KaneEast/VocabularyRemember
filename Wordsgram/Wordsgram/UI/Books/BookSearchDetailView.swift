//
//  BookSearchDetailView.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/19.
//

import SwiftUI

struct BookSearchDetailView: View {
  let book: Item
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 10) {
        // Book Image
        if let thumbnailUrl = URL(string: book.volumeInfo?.imageLinks?.thumbnail ?? ""),
           let imageData = try? Data(contentsOf: thumbnailUrl),
           let uiImage = UIImage(data: imageData) {
          Image(uiImage: uiImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(8)
        }
        
        
        if let volumeInfo = book.volumeInfo {
          // MARK: - Title
          Text(volumeInfo.title)
            .font(.title)
            .fontWeight(.bold)
          
          // MARK: - Authors
          ForEach(volumeInfo.authors, id: \.self) { author in
            Text(author)
              .font(.subheadline)
              .foregroundColor(.secondary)
          }
        }
        
        // Publishing Info
        Text("Published by \(book.volumeInfo?.publisher ?? "Unknown") on \(book.volumeInfo?.publishedDate ?? "Unknown")")
          .font(.footnote)
          .foregroundColor(.secondary)
        
        // Description
        if let description = book.volumeInfo?.description {
          Text(description)
            .font(.body)
        }
        
        // Additional Details
        HStack {
          if let pageCount = book.volumeInfo?.pageCount {
            Text("\(pageCount) pages")
              .font(.footnote)
          }
          
          if let averageRating = book.volumeInfo?.averageRating {
            Text("Rating: \(averageRating)/5")
              .font(.footnote)
          }
        }
        .foregroundColor(.secondary)
      }
      .padding()
    }
    .navigationBarTitle("Book Details", displayMode: .inline)
  }
}
