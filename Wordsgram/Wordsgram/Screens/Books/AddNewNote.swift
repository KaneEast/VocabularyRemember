//
//  AddNewNote.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/14.
//

import SwiftUI

struct AddNewNote: View {
    let book: Book
    
    @State private var title = NSMutableAttributedString(string: "")
    @State private var message = NSMutableAttributedString(string: "")
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
          TextView($title, getTextView: { textView in
          })
          .placeholder("Enter title")
          .setKeyboardType(.twitter)
          .roundedBorderStyle(color: .gray, width: 1, cornerRadius: 2)
          
          
          TextView($message, getTextView: { textView in
          })
          .placeholder("Enter title")
          .setKeyboardType(.twitter)
          .roundedBorderStyle(color: .gray, width: 1, cornerRadius: 2)
          .lineLimit(3...6)
        }
        .navigationTitle("Add new note")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                RedButton(title: "Close") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                RedButton(title: "Save") {
                  let note = Note(title: title.string, message: message.string)
                    note.book = book
                    context.insert(note)
                    
                    do {
                        try context.save()
                        book.notes.append(note)
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                    dismiss()
                }
            }
        }
    }
}
