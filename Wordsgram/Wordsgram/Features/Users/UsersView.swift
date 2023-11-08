//
//  UsersNavigationStack.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/04.
//

import SwiftUI
import Moya

struct UsersView: View {
    @State private var showingSheet = false
    @State private var users: [User] = []
    @State private var showingUserErrorAlert = false
//    @EnvironmentObject var auth: Auth
    
    var body: some View {
        NavigationStack {
            List(users, id: \.id) { user in
                VStack(alignment: .leading) {
                    Text(user.name).font(.title2)
                    Text(user.username).font(.caption)
                }
            }
            .navigationTitle("Users")
        }
        .onAppear(perform: loadData)
        .alert(isPresented: $showingUserErrorAlert) {
            Alert(title: Text("Error"), message: Text("There was an error getting the users"))
        }
    }
    
    func loadData() {
        let provider = MoyaProvider<WGService>()
        provider.rx.request(.requestUsers)
            .filterSuccessfulStatusCodes()
            .map([User].self)
            .subscribe { event in
                switch event {
                case let .success(users):
                    DispatchQueue.main.async {
                        self.users = users
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    self.showingUserErrorAlert = true
                }
            }//.dispose()
    }
}

#Preview {
    UsersView()
}

