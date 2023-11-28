//
//  BookCellView.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/14.
//

import SwiftUI

struct BookCellView: View {
  //let book: Book
  let title: String
  let author: String
  let cover: Data?
  var publishedYear: Int
  
  var body: some View {
    HStack(alignment: .top) {
      if let cover = cover, let image = UIImage(data: cover) {
        Image(uiImage: image)
          .resizable()
          .scaledToFit()
          .clipShape(.rect(cornerRadius: 5))
          .frame(width: 90, height: 90)
          .shadow(color: .red, radius: 3)
      }
      
      VStack(alignment: .leading) {
        Text(title)
          .bold()
        Group {
          Text("Author: \(author)")
          Text("Published on: \(publishedYear.description)")
        }
        .font(.footnote)
        .foregroundStyle(.secondary)
      }
    }
  }
}

#Preview {
  BookCellView(title: "Title", author: "author", cover: nil, publishedYear: 3023)
}
