//
//  WordNavigationStack.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/03.
//

import SwiftUI

struct WordsView: View {
    @State private var showingSheet = false
    @State private var showingAcronymErrorAlert = false
    @State private var isLoading = false
    @EnvironmentObject var auth: Auth
    
    @StateObject private var vm = WordsViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.words, id: \.id) { word in
                    NavigationLink(destination: WordDetailView(acronym: word)) {
                        VStack(alignment: .leading) {
                            Text(word.name).font(.title2)
                            Text(word.meaning).font(.caption)
                        }
                    }
                }
                .onDelete(perform: { indexSet in
                    vm.deleteOne()
                })
            }
            .navigationTitle("Words")
            .toolbar {
                Button(
                    action: { showingSheet.toggle() },
                    label: { Image(systemName: "plus") }
                )
            }
//            .overlay {
//                if isLoading && vm.words.isEmpty {
//                    ProgressView("Loading...")
//                }
//            }
            .sheet(isPresented: $showingSheet) {
                Text("create word view")
//                    .onDisappear(perform: loadData)
            }
        }
        .onAppear(perform: vm.getAllWords)
        .alert(isPresented: $showingAcronymErrorAlert) {
            Alert(title: Text("Error"), message: Text("There was an error getting the acronyms"))
        }
    }
}

#Preview {
    WordsView()
}
