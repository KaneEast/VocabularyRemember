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
  @State var routerPath = RouterManager.shared.bookTabRouter
  
  @State private var isEditing = false
  @State private var title: String = ""
  @State private var author: String = ""
  @State private var publishedYear: Int? = nil
  @State private var selectedGenres = Set<Genre>()
  @State private var selectedCover: PhotosPickerItem?
  @State private var selectedCoverData: Data?
  
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
        editigView
      } else {
        normalStateView
      }
      wordsSection
      notesSection
    }
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button { isEditing.toggle() } label: {
          Image(systemName: isEditing ? "checkmark.circle" : "square.and.pencil.circle")
        }
      }
    }
    .task(id: selectedCover) {
      if let data = try? await selectedCover?.loadTransferable(type: Data.self) {
        selectedCoverData = data
      }
    }
    .navigationTitle("Book Detail")
    .navigationBarTitleDisplayMode(.inline)
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
    
    do {
      try coordinator.save()
    } catch {
      print(error.localizedDescription)
    }
    
    dismiss()
  }
}

extension BookDetailView {
  @ViewBuilder
  private var editigView: some View {
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
  }
  
  @ViewBuilder
  private var normalStateView: some View {
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
      //          HStack {
      //            ForEach(book.genres) { genre in
      //              Text(genre.name)
      //                .font(.caption)
      //                .padding(.horizontal, 5)
      //                .padding(.vertical, 3)
      //                .background(.pink.opacity(0.3), in: Capsule())
      //            }
      //          }
      TagView(alignment: .center, spacing: 10){
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
  
  @ViewBuilder
  private var wordsSection: some View {
    Section(header: HStack {
      Text("Words")
        .font(.headline)
        .foregroundColor(.primary)
      
      Spacer()
      
      Button(action: {
        routerPath.presentedSheet = .addNewWord(book: book)
      }) {
        HStack {
          Image(systemName: "plus")
          Text("Add")
        }
      }
    }) {
      if book.words.isEmpty {
        ContentUnavailableView("No Words", systemImage: "note")
      } else {
        WordListView(book: book)
      }
    }
  }
  
  @ViewBuilder
  private var notesSection: some View {
    Section("Notes") {
      Button("Add new note") {
        routerPath.presentedSheet = .addNewNote(book: book)
      }
      if book.notes.isEmpty {
        ContentUnavailableView("No notes", systemImage: "note")
      } else {
        NotesListView(book: book)
      }
    }
  }
}

#Preview {
  let book = Book(title: "title", author: "author", publishedYear: 2023)
  return BookDetailView(book: book)
}