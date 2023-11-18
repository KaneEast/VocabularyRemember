//
//  UsersNavigationStack.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/04.
//

import SwiftUI

struct UsersView: View {
    @State private var showingSheet = false
    @State private var users: [User] = []
    @State private var showingUserErrorAlert = false
    @EnvironmentObject var service: UserService
    
    var body: some View {
        NavigationStack {
            List(service.users, id: \.id) { user in
                VStack(alignment: .leading) {
                    Text(user.name).font(.title2)
                    Text(user.username).font(.caption)
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Users")
        }
        .alert(isPresented: $showingUserErrorAlert) {
            Alert(title: Text("Error"), message: Text("There was an error getting the users"))
        }
    }
}

#Preview {
    UsersView()
}

