//
//  CreateWordView.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/08.
//

import SwiftUI
import Moya

struct CreateWordView: View {
    @State var name = ""
    @State var meaning = ""
    @Environment(\.presentationMode) var presentationMode
    @State private var showingWordSaveErrorAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Word").textCase(.uppercase)) {
                    TextField("Word", text: $name)
                        .autocapitalization(.allCharacters)
                        .disableAutocorrection(true)
                }
                Section(header: Text("Meaning").textCase(.uppercase)) {
                    TextField("Meaning", text: $meaning)
                        .autocapitalization(.words)
                }
            }
            .navigationBarTitle("Create Word", displayMode: .inline)
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
                    Button(action: saveWord) {
                        Text("Save")
                    }
                    .disabled(name.isEmpty || meaning.isEmpty)
            )
        }
        .alert(isPresented: $showingWordSaveErrorAlert) {
            Alert(title: Text("Error"), message: Text("There was a problem saving the Word"))
        }
    }
    
    // TODO: move to service use combine
    func saveWord() {
        guard name.count > 0, meaning.count > 0 else {
            showingWordSaveErrorAlert = true
            return
        }
        
        let provider = MoyaProvider<WGService>()
        provider.rx.request(.createWord(name: name, meaning: meaning))
            .filterSuccessfulStatusCodes()
            .map(CreateWordResponse.self)
            .subscribe { event in
                switch event {
                case let .success(word):
                    DispatchQueue.main.async {
                      presentationMode.wrappedValue.dismiss()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    self.showingWordSaveErrorAlert = true
                }
            }//.dispose()
    }
}

struct CreateWordView_Previews: PreviewProvider {
    static var previews: some View {
        CreateWordView()
    }
}

