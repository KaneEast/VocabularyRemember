//
//  UserService.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/10.
//

import SwiftUI
import CombineMoya
import Combine

class UserService: ObservableObject {
    @Published var users = [User]()
    var total: Int {
        users.count
    }
    
    func fetchAllFromServer() async throws {
        let results: [User] = try await  WGProviderFactory.shared.requestPublisher(.requestUsers)
            .filterSuccessfulStatusCodes()
            .map([User].self)
            .asyncValue()
        
        await MainActor.run {
            self.users = results
        }
    }
}
