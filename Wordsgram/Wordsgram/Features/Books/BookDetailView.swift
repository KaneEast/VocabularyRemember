//
//  BookDetailView.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/14.
//

import SwiftUI

struct BookDetailView: View {
    let book: Book
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var isEditing = false
    @State private var showAddNewNote = false
    @State private var title: String = ""
    @State private var author: String = ""
    @State private var publishedYear: Int? = nil
    @State private var selectedGenres = Set<Genre>()
    
    init(book: Book) {
        self.book = book
        self._title = State.init(initialValue: book.title)
        self._author = State.init(initialValue: book.author)
        self._publishedYear = State.init(initialValue: book.publishedYear)
        self._selectedGenres = State.init(initialValue: Set(book.genres))
    }
    
    var body: some View {
        Form {
            if isEditing {
                Group {
                    TextField("Book title", text: $title)
                    TextField("Book author", text: $author)
                    TextField("Published year", value: $publishedYear, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                    
                    GenreSelectionView(selectedGenres: $selectedGenres)
                                            .frame(height: 300)
                }
                .textFieldStyle(.roundedBorder)
                
                Button("Save", action: save)
            } else {
                Text(book.title)
                Text(book.author)
                Text(book.publishedYear.description)
                
                if !book.genres.isEmpty {
                    HStack {
                        ForEach(book.genres) { genre in
                            Text(genre.name)
                                .font(.caption)
                                .padding(.horizontal)
                                .background(.pink.opacity(0.3), in: Capsule())
                        }
                    }
                }
            }
            
            Section("Notes") {
                Button("Add new note") {
                    showAddNewNote.toggle()
                }
                .sheet(isPresented: $showAddNewNote, content: {
                    NavigationStack {
                        AddNewNote(book: book)
                    }
                    .presentationDetents([.fraction(0.3)])
                    .interactiveDismissDisabled()
                })
                
                if book.notes.isEmpty {
                    ContentUnavailableView("No notes", systemImage: "note")
                } else {
                    NotesListView(book: book)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                RedButton(title: isEditing ? "Done" : "Edit") {
                    isEditing.toggle()
                }
            }
        }
        .navigationTitle("Book Detail")
    }
    
    private func save() {
        guard let publishedYear = publishedYear else { return }
        book.title = title
        book.author = author
        book.publishedYear = publishedYear
        
        book.genres = []
        book.genres = Array(selectedGenres)
        selectedGenres.forEach { genre in
            if !genre.books.contains(where: { b in
                b.title == book.title
            }) {
                genre.books.append(book)
            }
        }
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        dismiss()
    }
}
