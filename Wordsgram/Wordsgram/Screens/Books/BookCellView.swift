//
//  BookCellView.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/14.
//

import SwiftUI

struct BookCellView: View {
    let book: Book
    
    var body: some View {
        HStack(alignment: .top) {
            if let cover = book.cover, let image = UIImage(data: cover) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .clipShape(.rect(cornerRadius: 5))
                    .frame(width: 70, height: 70)
            }
            
            VStack(alignment: .leading) {
                Text(book.title)
                    .bold()
                Group {
                    Text("Author: \(book.author)")
                    Text("Published on: \(book.publishedYear.description)")
                }
                .font(.footnote)
                .foregroundStyle(.secondary)
            }
        }
    }
}
