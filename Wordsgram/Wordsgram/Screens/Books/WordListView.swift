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
  @State var routerPath = RouterManager.shared.bookTabRouter
  @EnvironmentObject private var coordinator: WordCoordinator
  
  var body: some View {
//    TagView(alignment: .center, spacing: 10) {
//      ForEach(book.words) { word in
//        Button {
//          searchDictTerm = word.word
//        } label: {
//          Text(word.word)
//        }
//      }
//    }
        List {
          ForEach(book.words) { word in
            HStack {
              Text(word.word)
                .bold()
              Spacer()
              Button {
                routerPath.presentedSheet = .showDict(searchTerm: word.word)
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
