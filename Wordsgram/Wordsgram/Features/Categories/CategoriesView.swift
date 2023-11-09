//
//  CategoriesNavigationStack.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/04.
//

import SwiftUI
import Moya

struct CategoriesView: View {
    @EnvironmentObject var categoryService: CategoriesService
    @State private var showingSheet = false
    @State private var showingCategoryErrorAlert = false
    
    var body: some View {
        NavigationStack {
            let columns = [GridItem(),
                           GridItem(),
                           GridItem()
            ]
            
            ScrollView {
                LazyVGrid(columns: columns) {
//                List {
                    ForEach(categoryService.detailedCategories, id: \.category.id) { res in
                        ZStack  {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.orange)
//                                .frame(height: 150)
                            
                            VStack(alignment: .leading) {
                                Text(res.category.name)
                                    .font(.title2)
                                
                                Text("Words: \(res.words.count)")
                                    .font(.title3)
                            }
                        }
                        .onAppear {
                            print("Displaying category: \(res.category.name)")
                            print("Displaying category: \(res.category.id)")
                        }
//                        .frame(height: 150)
                        .frame(height: 50)
                        
                        
                    }
                }
                .onAppear {
                    print("CreateCategoryView - categories count: \(categoryService.detailedCategories.count)")
                    
                }
                .padding()
            }
            .navigationTitle("Categories")
            .toolbar {
                Button(
                    action: {
                        showingSheet.toggle()
                    }, label: {
                        Image(systemName: "plus")
                    })
            }
        }
        .sheet(isPresented: $showingSheet) {
            CreateCategoryView()
        }
        .alert(isPresented: $showingCategoryErrorAlert) {
            Alert(title: Text("Error"), message: Text("There was an error getting the words"))
        }
    }
}

#Preview {
    CategoriesView()
}
