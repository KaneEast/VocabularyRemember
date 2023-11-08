//
//  CategoriesNavigationStack.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/04.
//

import SwiftUI
import Moya

struct CategoriesView: View {
    @State private var showingSheet = false
    @State private var categories: [Category] = []
    @State private var showingCategoryErrorAlert = false
    
    var body: some View {
        NavigationStack {
            List(categories, id: \.id) { category in
                Text(category.name)
                    .font(.title2)
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
            //      CreateCategoryView()
            //        .onDisappear(perform: loadData)
        }
        .onAppear(perform: loadData)
        .alert(isPresented: $showingCategoryErrorAlert) {
            Alert(title: Text("Error"), message: Text("There was an error getting the acronyms"))
        }
    }
    
    func loadData() {
        let provider = MoyaProvider<WGService>()
        provider.rx.request(.requestCategories)
            .filterSuccessfulStatusCodes()
            .map([Category].self)
            .subscribe { event in
                switch event {
                case let .success(categories):
                    DispatchQueue.main.async {
                        self.categories = categories
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    self.showingCategoryErrorAlert = true
                }
            }//.dispose()
    }
}

#Preview {
    CategoriesView()
}
