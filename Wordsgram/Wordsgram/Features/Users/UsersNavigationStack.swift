//
//  UsersNavigationStack.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/04.
//

import SwiftUI

struct UsersNavigationStack: View {
    @State private var showingSheet = false
    @State private var users: [User] = []
    @State private var showingUserErrorAlert = false
    @EnvironmentObject var auth: Auth
//    let usersRequest = ResourceRequest<User>(resourcePath: "users")
    
    var body: some View {
        NavigationStack {
            List(users, id: \.id) { user in
                VStack(alignment: .leading) {
                    Text(user.name).font(.title2)
                    Text(user.username).font(.caption)
                }
            }
            .navigationTitle("Users")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(
                        action: { auth.logout() },
                        label: { Text("Log Out")}
                    )
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(
                        action: { showingSheet.toggle() },
                        label: { Image(systemName: "plus")}
                    )
                }
            }
        }
        .sheet(isPresented: $showingSheet) {
            //            CreateUserView()
            //                .onDisappear(perform: loadData)
        }
        .onAppear(perform: loadData)
        .alert(isPresented: $showingUserErrorAlert) {
            Alert(title: Text("Error"), message: Text("There was an error getting the users"))
        }
    }
    
    func loadData() {
//        usersRequest.getAll { userResult in
//            switch userResult {
//            case .failure:
//                DispatchQueue.main.async {
//                    self.showingUserErrorAlert = true
//                }
//            case .success(let users):
//                DispatchQueue.main.async {
//                    self.users = users
//                }
//            }
//        }
    }
}

#Preview {
    UsersNavigationStack()
}

