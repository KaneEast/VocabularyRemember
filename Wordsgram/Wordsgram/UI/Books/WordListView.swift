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
  @Environment(\.modelContext) private var context
  @State private var showDict = false
  @State private var showingWord = ""
  
  var body: some View {
    List {
      ForEach(book.words) { word in
        HStack {
          Text(word.word)
            .bold()
          Spacer()
          Button {
            showingWord = word.word
            showDict = true
            print(showingWord)
          } label: {
            HStack(spacing: 2) {
              Image(systemName: "rectangle.and.text.magnifyingglass")
              Text("Definition")
            }
          }
        }
      }
      
      .onDelete(perform: deleteNote(indexSet:))
    }
    .sheet(isPresented: $showDict){
      DictionaryView(word: showingWord)
    }
  }
  
  private func deleteNote(indexSet: IndexSet) {
    indexSet.forEach { index in
      let word = book.words[index]
      context.delete(word)
      book.words.remove(at: index)
      do {
        try context.save()
      } catch {
        print(error.localizedDescription)
      }
    }
  }
}

