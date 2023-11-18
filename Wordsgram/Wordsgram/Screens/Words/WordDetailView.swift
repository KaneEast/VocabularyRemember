//
//  WordDetailView.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/03.
//

import SwiftUI

struct WordDetailView: View {
  var word: Word
  @State private var user: User?
  @State private var categories: [Category] = []
  @State private var short = ""
  @State private var long = ""
  @State private var showingSheet = false
  @State var selectedItem: Category?
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var categoryService: CategoriesService
  
  var body: some View {
    VStack {
      Form {
        Section(header: Text("Word").textCase(.uppercase)) {
          Text(word.name)
        }
        Section(header: Text("Meaning").textCase(.uppercase)) {
          Text(word.meaning)
        }
        if let user = user {
          Section(header: Text("User").textCase(.uppercase)) {
            Text(user.name)
          }
        }
        
        Section(header: Text("Categories").textCase(.uppercase)) {
          AddToCategoryView(word: word, selectedItem: $selectedItem)
        }
      }
      
      Spacer()
    }
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button(action: addToCategory, label: {
          Text("save")
        })
      }
    }
    .navigationBarTitleDisplayMode(.inline)
    .onAppear(perform: loadData)
  }
  
  func loadData() {
    guard let wid = word.id else {
      return
    }
    
    categoryService.getCategoryOfWord(wordID: wid)
    self.selectedItem = categories.first
  }
  
  // TODO: move to service use combine
  func addToCategory() {
  }
}
