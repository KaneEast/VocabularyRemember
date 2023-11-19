//
//  UserService.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/10.
//

import SwiftUI
import Combine

class UserService: ObservableObject {
  @Published var users = [User]()
  var total: Int {
    users.count
  }
  var cancellables = Set<AnyCancellable>()
  
  func fetchAllFromServer() async throws {
    RequestUsersRequest().request()
      .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
          break
        case .failure(let error):
          print("Error: \(error)")
        }
      }, receiveValue: { result in
        self.users = result
      })
      .store(in: &cancellables)
  }
}
