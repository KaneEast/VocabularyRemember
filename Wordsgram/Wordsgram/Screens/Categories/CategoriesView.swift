//
//  CategoriesNavigationStack.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/04.
//

import SwiftUI

struct CategoriesView: View {
  @State private var routerPath = RouterPath()
  @EnvironmentObject var categoryService: CategoriesService
  @State private var showingSheet = false
  @State private var showingCategoryErrorAlert = false
  
  var body: some View {
    NavigationStack {
      let columns = [
        GridItem(),
        GridItem()
      ]
      
      ScrollView {
        LazyVGrid(columns: columns) {
          ForEach(categoryService.detailedCategories, id: \.category.id) { res in
            ZStack  {
              RoundedRectangle(cornerRadius: 20)
                .fill(Color.orange)
                .frame(height: 150)
              
              VStack(alignment: .leading) {
                Text(res.category.name)
                  .font(.title2)
                Text("Words: \(res.words.count)")
                  .font(.title3)
              }
            }
            .frame(height: 150)
          }
        }
        .padding()
      }
      .navigationTitle("Categories")
      .toolbar {
        Button(action: {
          routerPath.presentedSheet = .createCategory
        }, label: {
          Image(systemName: "plus.circle")
        })
      }
      .withAppRouter()
      .withSheetDestinations(sheetDestinations: $routerPath.presentedSheet)
    }
    .alert(isPresented: $showingCategoryErrorAlert) {
      Alert(title: Text("Error"), message: Text("There was an error getting the words"))
    }
  }
}

#Preview {
  CategoriesView()
}
