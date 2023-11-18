//
//  WordNavigationStack.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/03.
//

import SwiftUI

struct WordsView: View {
    @State private var routerPath = RouterPath()
    @State private var showingSheet = false
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
            .listStyle(PlainListStyle())
            .withAppRouter()
            .withSheetDestinations(sheetDestinations: $routerPath.presentedSheet)
            .navigationTitle("Words")
            .toolbar {
                Button(
                    action: { showingSheet.toggle() },
                    label: { Image(systemName: "plus.circle") }
                )
            }
            .sheet(isPresented: $showingSheet) {
                CreateWordView()
                //.onDisappear(perform: fetchWords)
            }
        }
        .onAppear {
          fetchWords()
        }
    }
    
    func fetchWords() {
        Task { wordsService.fetchAllFromServer }
    }
}

#Preview {
    WordsView()
        .environmentObject(WordsService(words: [Word(
            name: "a",
            meaning: "b",
            userID: UUID())
        ]))
}
