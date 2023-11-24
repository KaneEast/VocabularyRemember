//
//  CreateWordView.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/08.
//

import SwiftUI

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
            .disableAutocorrection(true)
        }
        Section(header: Text("Meaning").textCase(.uppercase)) {
          TextField("Meaning", text: $meaning)
            .disableAutocorrection(true)
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
      ).foregroundColor(.red)
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
  }
}

struct CreateWordView_Previews: PreviewProvider {
  static var previews: some View {
    CreateWordView()
  }
}

