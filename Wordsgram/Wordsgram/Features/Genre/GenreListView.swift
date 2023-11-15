//
//  GenreListView.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/14.
//

import Foundation
import SwiftUI
import SwiftData

struct GenreListView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Genre.name) private var genres: [Genre]
    @State private var presentAddNew = false
    @State private var sortOption: GenreSortOrder = .forward
    
    var body: some View {
        NavigationStack {
            GenreListSubview(sortOrder: sortOption)
                .navigationTitle("Literary Genres")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button{
                            presentAddNew.toggle()
                        } label: {
                            Image(systemName: "plus")
                        }
                        .sheet(isPresented: $presentAddNew, content: {
                            AddNewGenre()
                                .presentationDetents([.fraction(0.3)])
                                .interactiveDismissDisabled()
                        })
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Button{
                            sortOption = sortOption == .forward ? .reverse : .forward
                        } label: {
                            Image(systemName: "arrow.up.arrow.down")
                        }
                    }
                }
        }
    }
}

#Preview {
    GenreListView()
}
