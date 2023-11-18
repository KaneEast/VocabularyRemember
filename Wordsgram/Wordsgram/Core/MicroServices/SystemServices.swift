//
//  SystemServices.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/09.
//

import SwiftUI
import SwiftData

struct SystemServices: ViewModifier {
    private static var appState: AppState = AppState()
    private static var auth = AuthService.shared
    private static var words = WordsService()
    private static var categories = CategoriesService()
    private static var users = UserService()
    private static var bookService = BookService()
    
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
            // TODO: catch errors
            do {
                try await SystemServices.words.fetchAllFromServer()
                try await SystemServices.categories.fetchAllFromServer()
                try await SystemServices.categories.fetchCategories()
                try await SystemServices.users.fetchAllFromServer()
            } catch {
                print("An error occurred: \(error)")
            }
        }
    }
}
