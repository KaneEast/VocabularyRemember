//
//  WordNavigationStack.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/03.
//

import SwiftUI

struct WordNavigationStack: View {
    @State private var showingSheet = false
    @State private var showingAcronymErrorAlert = false
    @EnvironmentObject var auth: Auth
    @State private var words: [Word] = []
    let acronymsRequest = ResourceRequest<Word>(resourcePath: "words")
    
    var body: some View {
        NavigationStack {
            Group {
                if !words.isEmpty {
                    List {
                        ForEach(words, id: \.id) { acronym in
                            NavigationLink(destination: WordDetailView(acronym: acronym)
                                .onDisappear(perform: loadData)) {
                                    VStack(alignment: .leading) {
                                        Text(acronym.name).font(.title2)
                                        Text(acronym.meaning).font(.caption)
                                    }
                                }
                        }
                        .onDelete(perform: { indexSet in
                        })
                    }
                    
                } else {
                    ContentUnavailableView("No Account Found", systemImage: "bird")
                }
            }
            .navigationTitle("Account")
            .toolbar {
                Button(
                    action: {
                        showingSheet.toggle()
                    }, label: {
                        Image(systemName: "plus")
                    })
            }
            .sheet(isPresented: $showingSheet) {
                Text("create word view")
                    .onDisappear(perform: loadData)
            }
        }
        .onAppear(perform: loadData)
        .alert(isPresented: $showingAcronymErrorAlert) {
            Alert(title: Text("Error"), message: Text("There was an error getting the acronyms"))
        }
    }
    
    func loadData() {
        acronymsRequest.getAll { acronymResult in
            switch acronymResult {
            case .failure:
                DispatchQueue.main.async {
                    self.showingAcronymErrorAlert = true
                }
            case .success(let words):
                DispatchQueue.main.async {
                    self.words = words
                }
            }
        }
    }
}

#Preview {
    WordNavigationStack()
    //        .backyardBirdsDataContainer(inMemory: true)
}
