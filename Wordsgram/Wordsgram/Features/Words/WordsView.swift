//
//  WordNavigationStack.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/03.
//

import SwiftUI

struct WordsView: View {
    @State private var showingSheet = false
    @State private var showingErrorAlert = false
    @State private var isLoading = false
    @EnvironmentObject var wordsService: WordsService
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(wordsService.words, id: \.id) { word in
                    NavigationLink(destination: WordDetailView(word: word)) {
                        VStack(alignment: .leading) {
                            Text(word.name).font(.title2)
                            Text(word.meaning).font(.caption)
                        }
                    }
                }
                //.onDelete(perform: { indexSet in
                //})
            }
            .navigationTitle("Words")
            .toolbar {
                Button(
                    action: { showingSheet.toggle() },
                    label: { Image(systemName: "plus") }
                )
            }
            .sheet(isPresented: $showingSheet) {
                CreateWordView().onDisappear(perform: fetch)
            }
        }
        .alert(isPresented: $showingErrorAlert) {
            Alert(title: Text("Error"), message: Text("There was an error getting the words"))
        }
    }
    
    func fetch() {
        Task { wordsService.fetchAllFromServer }
    }
}

//#Preview {
//    WordsView()
//}
