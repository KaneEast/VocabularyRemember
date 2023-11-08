//
//  CreateCategoryView.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/09.
//

import SwiftUI
import Moya

struct CreateCategoryView: View {
    @State var name = ""
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var auth: Auth
    @State private var showingCategorySaveErrorAlert = false
    
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
        .alert(isPresented: $showingCategorySaveErrorAlert) {
            Alert(title: Text("Error"), message: Text("There was a problem saving the category"))
        }
    }
    
    func saveCategory() {
        guard name.count > 0 else {
            showingCategorySaveErrorAlert = true
            return
        }
        
        let provider = MoyaProvider<WGService>()
        provider.rx.request(.createCategory(name: name))
            .filterSuccessfulStatusCodes()
            .map(Category.self)
            .subscribe { event in
                switch event {
                case let .success(category):
                    DispatchQueue.main.async {
                      presentationMode.wrappedValue.dismiss()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    self.showingCategorySaveErrorAlert = true
                }
            }//.dispose()
    }
}

struct CreateCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CreateCategoryView()
    }
}

