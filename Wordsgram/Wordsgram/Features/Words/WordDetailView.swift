//
//  WordDetailView.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/03.
//

import SwiftUI
import Moya

struct WordDetailView: View {
    var word: Word
    @State private var user: User?
    @State private var categories: [Category] = []
    @State private var short = ""
    @State private var long = ""
    @State private var showingSheet = false
    @State private var isShowingAddToCategoryView = false
    @State private var showingSaveSuccessAlert = false
    @State private var showingCategoriesErrorAlert = false
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
            Button(
                action: addToCategory,
                label: {
                    Text("Save")
                        .modifier(MainButton(color: Color.red))
                }
            )
            .padding(.horizontal, 80)
            
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            Button(
//                action: {
//                    showingSheet.toggle()
//                }, label: {
//                    Text("Edit")
//                })
//        }
        .sheet(isPresented: $showingSheet) {
            //
        }
        .onAppear(perform: loadData)
        .alert(isPresented: $showingSaveSuccessAlert) {
            Alert(title: Text("Success"), message: Text("Succesfully changed Category."))
        }
        .alert(isPresented: $showingCategoriesErrorAlert) {
            Alert(title: Text("Error"), message: Text("Category change failed."))
        }
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
        guard let wid = word.id, let cid = selectedItem?.id else {
            return
        }
        let provider = WGProviderFactory.makeProvider()
        provider.rx.request(.addToCategory(wordID: wid.uuidString, categoryID: cid.uuidString))
            .filterSuccessfulStatusCodes()
            .subscribe { event in
                switch event {
                case .success:
                    DispatchQueue.main.async {
                        self.showingSaveSuccessAlert = true
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        print(error.localizedDescription)
                        self.showingSheet = true
                    }
                }
            }//.dispose()
    }
}
