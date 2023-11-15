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
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var author: String = ""
    @State private var publishedYear: Int?
    @State private var selectedGenres = Set<Genre>()
    
    @State private var selectedCover: PhotosPickerItem?
    @State private var selectedCoverData: Data?
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Book title:")
                TextField("Enter title", text: $title)
                    .textFieldStyle(.roundedBorder)
                
                Text("Author:")
                TextField("Enter book author", text: $author)
                    .textFieldStyle(.roundedBorder)
                
                HStack {
                    PhotosPicker(
                        selection: $selectedCover,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        Label("Add Cover", systemImage: "book.closed")
                            .foregroundColor(.red)
                    }
                    .padding(.vertical)
                    
                    Spacer()
                    
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
                    }
                }
                
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
        
        if let selectedCoverData {
            book.cover = selectedCoverData
        }
        
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
