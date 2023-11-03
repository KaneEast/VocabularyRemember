//
//  WordDetailView.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/03.
//
import SwiftUI

struct WordDetailView: View {
    var acronym: Word
    @State private var user: User?
    @State private var categories: [Category] = []
    @State private var short = ""
    @State private var long = ""
    @State private var showingSheet = false
    @State private var isShowingAddToCategoryView = false
    @State private var showingUserErrorAlert = false
    @State private var showingCategoriesErrorAlert = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form {
            Section(header: Text("Acronym").textCase(.uppercase)) {
                Text(acronym.name)
            }
            Section(header: Text("Meaning").textCase(.uppercase)) {
                Text(acronym.meaning)
            }
            if let user = user {
                Section(header: Text("User").textCase(.uppercase)) {
                    Text(user.name)
                }
            }
            if !categories.isEmpty {
                Section(header: Text("Categories").textCase(.uppercase)) {
                    List(categories, id: \.id) { category in
                        Text(category.name)
                    }
                }
            }
            Section {
                Button("Add To Category") {
                    isShowingAddToCategoryView = true
                }
            }
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
//        .sheet(isPresented: $showingSheet) {
//            EditAcronymView(acronym: acronym)
//        }
//        NavigationLink(destination: AddToCategoryView(acronym: acronym, selectedCategories: self.categories), isActive: $isShowingAddToCategoryView) {
//            EmptyView()
//        }
//        .onAppear(perform: getAcronymData)
//        .alert(isPresented: $showingUserErrorAlert) {
//            Alert(title: Text("Error"), message: Text("There was an error getting the acronym's user"))
//        }
//        .alert(isPresented: $showingCategoriesErrorAlert) {
//            Alert(title: Text("Error"), message: Text("There was an error getting the acronym's categories"))
//        }
    }
}
