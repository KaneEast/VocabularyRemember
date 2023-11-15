//
//  AddNewGenre.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/14.
//

import SwiftUI
import SwiftData

struct AddNewGenre: View {
    @State private var name: String = ""
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @FocusState private var nameIsFocused: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Add New Genre", text: $name)
                    .focused($nameIsFocused)
                    .textFieldStyle(.roundedBorder)
                    .navigationTitle("Add New Genre")
                    .navigationBarTitleDisplayMode(.inline)
                    .padding(.horizontal)
                
                HStack {
                    Button("Save") {
                        let genre = Genre(name: name)
                        context.insert(genre)
                        do {
                            try context.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                    .foregroundColor(.red)
                    
                    Button("Cancel") {
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                    .foregroundColor(.red)
                }
                
                Spacer()
            }
            .task {
                nameIsFocused = true
            }
        }
    }
}

#Preview {
    AddNewGenre()
}
