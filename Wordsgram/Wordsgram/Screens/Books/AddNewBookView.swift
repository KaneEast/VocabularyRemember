//
//  AddNewBookView.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/14.
//

import SwiftUI
import SwiftData
import PhotosUI

struct AddNewBookView: View {
  @EnvironmentObject var service: BookService
  @EnvironmentObject var provider: BookProvider
  @Environment(\.dismiss) private var dismiss

  @State var title = NSMutableAttributedString(string: "")
  @State private var author: String = ""
  @State private var publishedYear: Int?
  @State private var selectedGenres = Set<Genre>()
  
  @State private var selectedCover: PhotosPickerItem?
  @State private var selectedCoverData: Data?
  @State private var bookItem: Item?
  
  var body: some View {
    NavigationStack {
      VStack(alignment: .leading) {
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
            TextView($title,
                     getTextView: { textView in
              
            })
            .placeholder("Enter title")
            .setKeyboardType(.twitter)
            .roundedBorderStyle(color: .gray, width: 1, cornerRadius: 2)
            
            TextField("Enter book author", text: $author)
              .roundedBorderStyle(color: .gray, width: 1, cornerRadius: 2)
            TextField("Enter published year", value: $publishedYear, format: .number)
              .roundedBorderStyle(color: .gray, width: 1, cornerRadius: 2)
              .keyboardType(.numberPad)
          }
        }
        
        GenreSelectionView(selectedGenres: $selectedGenres)
        
        if let bookItem {
          BookSearchDetailView(book: bookItem)
        }
      }
      .padding()
      .navigationTitle("Add New Book")
      .navigationBarTitleDisplayMode(.inline)
      .task(id: selectedCover) {
        /// Notice that we are using the loadTransferable function with the photoPickerItem.
        /// This function grants us the capability to convert the foundational data, and as photoPickerItem conforms
        /// to the Transferable protocol, it enables our model to engage in system sharing and data transfer process.
        if let data = try? await selectedCover?.loadTransferable(type: Data.self) {
          selectedCoverData = data
        }
      }
      .gesture(
        DragGesture().onChanged { _ in
          UIApplication.dismissKeyboard()
        }
      )
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button("Cancel", role: .destructive) {
            dismiss()
          }.buttonStyle(.bordered)
        }
      }
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button("Save", role: .destructive) {
            save()
            //            search()
          }.buttonStyle(.borderedProminent)
        }
      }
    }
  }
  
  private var isValid: Bool {
    !title.string.isEmpty && !author.isEmpty && publishedYear != nil
  }
  
  private func search() {
    Task {
      do {
        let response = try await service.searchBook(title: title.string, author: author)
        print("=========================")
        print(response.items.first ?? "")
        print("=========================")
        print(response.items.first?.volumeInfo?.imageLinks?.thumbnail ?? "")
        self.bookItem = response.items.first
      } catch {
        print(error)
      }
    }
  }
  
  private func save() {
    guard let publishedYear else { return }
    let book = Book(title: title.string, author: author,
                    publishedYear: publishedYear)
    book.genres = Array(selectedGenres)
    book.cover = selectedCoverData
    do {
      try provider.set(item: book)
    } catch {
      print(error.localizedDescription)
    }
    
    dismiss()
  }
}

#Preview {
  AddNewBookView()
}
