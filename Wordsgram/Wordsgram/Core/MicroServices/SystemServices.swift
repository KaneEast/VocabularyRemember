//
//  SystemServices.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/09.
//

import SwiftUI
import SwiftData

struct SystemServices: ViewModifier {
  private static var appState     = AppState()
  private static var auth         = AuthService.shared
  private static var words        = WordsService()
  private static var categories   = CategoriesService()
  private static var users        = UserService()
  private static var bookService  = BookService()
  
  func body(content: Content) -> some View {
    content
      .accentColor(.primaryRed)
      .environmentObject(Self.auth)
      .environmentObject(Self.appState)
      .environmentObject(Self.words)
      .environmentObject(Self.categories)
      .environmentObject(Self.users)
      .environmentObject(Self.bookService)
    //.withModelContainer()
  }
  
  static func fetch() {
    Task {
      do {
        async let fetchWords: ()          = SystemServices.words.fetchAllFromServer()
        async let fetchCategories: ()     = SystemServices.categories.fetchAllFromServer()
        async let fetchMoreCategories: () = SystemServices.categories.fetchCategories()
        async let fetchUsers: ()          = SystemServices.users.fetchAllFromServer()
        
        // 这里你可以等待所有任务完成
        _ = try await [fetchWords, fetchCategories, fetchMoreCategories, fetchUsers]
      } catch {
        print("An error occurred: \(error)")
      }
    }
    
  }
}
