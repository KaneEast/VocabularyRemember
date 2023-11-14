//
//  AddNewBookView.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/14.
//

import SwiftUI
import SwiftData

struct AddNewBookView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var author: String = ""
    @State private var publishedYear: Int?
    @State private var selectedGenres = Set<Genre>()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Book title:")
                TextField("Enter title", text: $title)
                    .textFieldStyle(.roundedBorder)
                
                Text("Author:")
                TextField("Enter book author", text: $author)
                    .textFieldStyle(.roundedBorder)
                
                Text("Published:")
                TextField("Enter published year", value: $publishedYear, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                
                GenreSelectionView(selectedGenres: $selectedGenres)
                
                HStack {
                    Button("Cancel", role: .destructive) {
                        dismiss()
                    }.buttonStyle(.bordered)
                    
                    Spacer()
                    
                    Button("Save", role: .destructive) {
                        save()
                    }.buttonStyle(.bordered)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Add New Book")
        }
    }
    
    private var isValid: Bool {
        !title.isEmpty && !author.isEmpty && publishedYear != nil
    }
    
    private func save() {
        guard let publishedYear else { return }
        let book = Book(title: title, author: author,
                        publishedYear: publishedYear)
        
        book.genres = Array(selectedGenres)
        selectedGenres.forEach { genre in
            genre.books.append(book)
            context.insert(genre)
        }
        
        context.insert(book)
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        dismiss()
    }
}

#Preview {
    AddNewBookView()
}
