//
//  SystemServices.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/09.
//

import SwiftUI

struct SystemServices: ViewModifier {
//    private static var appState: AppState = AppState()
//    private static var auth = AuthService()
    private static var words = WordsService()
    private static var categories = CategoriesService()
    private static var users = UserService()

    func body(content: Content) -> some View {
        content
            .accentColor(.red)
            .environmentObject(AuthService.shared)
//            .environmentObject(Self.appState)
            .environmentObject(Self.words)
            .environmentObject(Self.categories)
            .environmentObject(Self.users)
    }
    
    func fetch() {
        Task {
            try? await SystemServices.words.fetchAllFromServer()
            try? await SystemServices.categories.fetchAllFromServer()
            try? await SystemServices.categories.fetchCategories()
            try? await SystemServices.users.fetchAllFromServer()
        }
        
        
    }
}
