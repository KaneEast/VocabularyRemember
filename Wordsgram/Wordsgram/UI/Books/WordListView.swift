//
//  WordListView.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/21.
//

import SwiftUI
import SwiftData

struct WordListView: View {
  let book: Book
  @EnvironmentObject private var coordinator: WordCoordinator
  @Binding var searchDictTerm: String
  
  var body: some View {
    List {
      ForEach(book.words) { word in
        HStack {
          Text(word.word)
            .bold()
          Spacer()
          Button {
            searchDictTerm = word.word
          } label: {
            HStack(spacing: 2) {
              Image(systemName: "rectangle.and.text.magnifyingglass")
              Text("Definition")
            }
          }
        }
      }
      .onDelete(perform: delete(indexSet:))
    }
  }
  
  private func delete(indexSet: IndexSet) {
    indexSet.forEach { index in
      let word = book.words[index]
      do {
        book.words.remove(at: index)
        try coordinator.deldete(words: [word])
      } catch {
        print(error.localizedDescription)
      }
    }
  }
}
