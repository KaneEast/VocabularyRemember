//
//  AddToCategoryView.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/09.
//

import SwiftUI

struct AddToCategoryView: View {
  var word: Word
  @EnvironmentObject var categoryService: CategoriesService
  @State private var showingCategoryErrorAlert = false
  @State private var showingAddCategoryToWordErrorAlert = false
  
  @Environment(\.presentationMode) var presentationMode
  
  @Binding var selectedItem: Category?
  
  var body: some View {
    List($categoryService.categories, id: \.id, selection: $selectedItem) { item in
      HStack {
        Text(item.wrappedValue.name)
        Spacer()
        if selectedItem?.id == item.wrappedValue.id {
          Image(systemName: "checkmark")
            .foregroundColor(.blue)
        }
      }
      .contentShape(Rectangle()) // Make the entire row tappable
      .onTapGesture {
        selectedItem = item.wrappedValue
      }
    }
    
    .alert(isPresented: $showingCategoryErrorAlert) {
      Alert(title: Text("Error"), message: Text("There was an error getting the categories"))
    }
    .alert(isPresented: $showingAddCategoryToWordErrorAlert) {
      let message = """
        There was an error adding the word
        to the category
        """
      return Alert(title: Text("Error"), message: Text(message))
    }
  }
}

//#Preview {
//    AddToCategoryView(word: Word, selectedCategories: [Category])
//}


