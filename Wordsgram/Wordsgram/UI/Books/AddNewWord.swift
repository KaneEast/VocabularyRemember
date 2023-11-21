//
//  AddNewWord.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/21.
//

import SwiftUI

struct AddNewWord: View {
  let book: Book
  
  @State private var word = NSMutableAttributedString(string: "")
  
  @Environment(\.modelContext) private var context
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    Form {
      TextView($word, getTextView: { textView in
      })
      .placeholder("Enter title")
      .setKeyboardType(.twitter)
      .roundedBorderStyle(color: .gray, width: 1, cornerRadius: 2)
    }
    .navigationTitle("Add New Word")
    .toolbar {
      ToolbarItem(placement: .topBarLeading) {
        RedButton(title: "Close") {
          dismiss()
        }
      }
      
      ToolbarItem(placement: .topBarTrailing) {
        RedButton(title: "Save") {
          let word = NewWord(word: word.string)
          word.book = book
          context.insert(word)
          
          do {
            try context.save()
            book.words.append(word)
          } catch {
            print(error.localizedDescription)
          }
          
          dismiss()
        }
      }
    }
  }
}

