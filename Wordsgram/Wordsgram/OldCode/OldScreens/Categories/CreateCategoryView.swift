//
//  CreateCategoryView.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/09.
//

import SwiftUI
//import Moya

struct CreateCategoryView: View {
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var categoryService: CategoriesService
  @State var name = ""
  @State private var isShowError = false
  
  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Name").textCase(.uppercase)) {
          TextField("Name", text: $name)
        }
      }
      .navigationBarTitle("Create Category", displayMode: .inline)
      .navigationBarItems(
        leading:
          Button(
            action: {
              presentationMode.wrappedValue.dismiss()
            }, label: {
              Text("Cancel")
                .fontWeight(Font.Weight.regular)
            }),
        trailing:
          Button(action: saveCategory) {
            Text("Save")
          }
          .disabled(name.isEmpty)
      )
    }
    .alert(isPresented: $isShowError) {
      Alert(title: Text("Error"), message: Text("There was a problem saving the category"))
    }
  }
  
  func saveCategory() {
    guard name.count > 0 else {
      // TODO: show error
      return
    }
    
    Task {
      do {
        try await categoryService.saveCategory(name: name)
        try await categoryService.fetchAllFromServer()
        await MainActor.run {
          presentationMode.wrappedValue.dismiss()
        }
        
      } catch {
        print(error.localizedDescription)
        await MainActor.run {
          presentationMode.wrappedValue.dismiss()
        }
      }
    }
  }
}

//struct CreateCategoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateCategoryView(categoryService: CategoriesService())
//    }
//}

