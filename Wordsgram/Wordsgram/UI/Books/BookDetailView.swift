//
//  BookDetailView.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/14.
//

import SwiftUI
import SwiftData
import PhotosUI

struct BookDetailView: View {
  let book: Book
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject private var coordinator: BookCoordinator
  @EnvironmentObject private var genreCoordinator: GenreCoordinator
  
  @State private var isEditing = false
  @State private var showAddNewNote = false
  @State private var showAddNewWord = false
  @State private var title: String = ""
  @State private var author: String = ""
  @State private var publishedYear: Int? = nil
  @State private var selectedGenres = Set<Genre>()
  @State private var selectedCover: PhotosPickerItem?
  @State private var selectedCoverData: Data?
  @State private var showDict = false
  @State private var searchDictTerm = ""
  
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
          HStack {
            PhotosPicker(
              selection: $selectedCover,
              matching: .images,
              photoLibrary: .shared()
            ) {
              if let selectedCoverData, let image = UIImage(data: selectedCoverData) {
                Image(uiImage: image)
                  .resizable()
                  .scaledToFit()
                  .clipShape(.rect(cornerRadius: 10))
                  .frame(width: 100, height: 100)
              } else {
                Image(systemName: "photo")
                  .resizable()
                  .scaledToFit()
                  .frame(width: 100, height: 100)
                  .foregroundColor(.aPrimaryRed)
              }
            }
            
            VStack {
              TextField("Enter title", text: $title)
                .roundedBorderStyle(color: .gray, width: 1, cornerRadius: 2)
                .disableAutocorrection(true)
              TextField("Enter book author", text: $author)
                .roundedBorderStyle(color: .gray, width: 1, cornerRadius: 2)
                .disableAutocorrection(true)
              TextField("Enter published year", value: $publishedYear, format: .number)
                .roundedBorderStyle(color: .gray, width: 1, cornerRadius: 2)
                .keyboardType(.numberPad)
                .disableAutocorrection(true)
            }
          }
          
          GenreSelectionView(selectedGenres: $selectedGenres)
            .frame(height: 300)
        }
        .textFieldStyle(.roundedBorder)
        
        Button("Save", action: save)
      } else {
        HStack {
          if let cover = book.cover, let image = UIImage(data: cover) {
            Image(uiImage: image)
              .resizable()
              .scaledToFit()
              .clipShape(.rect(cornerRadius: 5))
              .frame(height: 100)
          }
          
          VStack(alignment: .leading) {
            Text(book.title)
            Text(book.author)
            Text(book.publishedYear.description)
          }
        }
        
        if !book.genres.isEmpty {
          HStack {
            ForEach(book.genres) { genre in
              Text(genre.name)
                .font(.caption)
                .padding(.horizontal, 5)
                .padding(.vertical, 3)
                .background(.pink.opacity(0.3), in: Capsule())
            }
          }
        }
      }
      
      Section("Words") {
        Button("Add new word") {
          showAddNewWord.toggle()
        }
        .sheet(isPresented: $showAddNewWord, content: {
          NavigationStack {
            AddNewWord(book: book)
          }
          .presentationDetents([.fraction(0.9), .fraction(0.6), .fraction(0.3)])
          //.interactiveDismissDisabled()
        })
        
        if book.notes.isEmpty {
          ContentUnavailableView("No Words", systemImage: "note")
        } else {
          WordListView(book: book, searchDictTerm: $searchDictTerm)
        }
      }
      
      //      Section("Notes") {
      //        Button("Add new note") {
      //          showAddNewNote.toggle()
      //        }
      //        .sheet(isPresented: $showAddNewNote, content: {
      //          NavigationStack {
      //            AddNewNote(book: book)
      //          }
      //          .presentationDetents([.fraction(0.9), .fraction(0.6), .fraction(0.3)])
      //          //.interactiveDismissDisabled()
      //        })
      //
      //        if book.notes.isEmpty {
      //          ContentUnavailableView("No notes", systemImage: "note")
      //        } else {
      //          NotesListView(book: book)
      //        }
      //      }
    }
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button { isEditing.toggle() } label: {
          Image(systemName: isEditing ? "checkmark.circle" : "square.and.pencil.circle")
        }
      }
    }
    .onChange(of: searchDictTerm) {
      if !searchDictTerm.isEmpty {
        showDict = true
      }
    }
    .sheet(isPresented: $showDict){
      DictionaryView(word: searchDictTerm)
        .onDisappear {
          searchDictTerm = ""
        }
    }
    .onAppear {
      let res = UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: "Book")
      print(res)
    }
    .task(id: selectedCover) {
      if let data = try? await selectedCover?.loadTransferable(type: Data.self) {
        selectedCoverData = data
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
    
    if let selectedCoverData {
      book.cover = selectedCoverData
    }
    
    selectedGenres.forEach { genre in
      if !genre.books.contains(where: { b in
        b.title == book.title
      }) {
        genre.books.append(book)
      }
    }
    
    try? coordinator.save()
    dismiss()
  }
}

#Preview {
  let book = Book(title: "title", author: "author", publishedYear: 2023)
  return BookDetailView(book: book)
}
