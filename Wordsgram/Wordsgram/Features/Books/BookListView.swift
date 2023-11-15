//
//  BookListView.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/14.
//

import SwiftUI
import SwiftData

struct BookListView: View {
    @Environment(\.modelContext) private var context
    @Query private var books: [Book]
    @State private var presentAddNew = false
    
    @State private var searchTerm: String = ""
    var filteredBooks: [Book] {
        guard searchTerm.isEmpty == false else { return books }
        return books.filter { $0.title.localizedCaseInsensitiveContains(searchTerm) }
    }
    @State private var bookSortOption = SortingOption.none
    
    var body: some View {
        NavigationStack {
            BookListSubview(searchTerm: searchTerm, bookSortOption: bookSortOption)
                .searchable(text: $searchTerm, prompt: "Search book title")
                .navigationTitle("Reading Logs")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button{
                            presentAddNew.toggle()
                        } label: {
                            Image(systemName: "plus")
                        }
                        .sheet(isPresented: $presentAddNew, content: {
                            AddNewBookView()
                        })
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            ForEach(SortingOption.allCases) { sortOption in
                                Button(sortOption.title) {
                                    bookSortOption = sortOption
                                }
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                        
                    }
                }
            
        }
    }
}

#Preview {
    BookListView().modelContainer(for: [Book.self])
}
