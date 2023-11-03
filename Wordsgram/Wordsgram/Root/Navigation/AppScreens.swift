//
//  AppScreen.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/03.
//

import SwiftUI

enum AppScreen: Codable, Hashable, Identifiable, CaseIterable {
    case words
    case users
    case categories
//    case account
    
    var id: AppScreen { self }
}

extension AppScreen {
    @ViewBuilder
    var label: some View {
        switch self {
        case .words:
            Label("words", systemImage: "person.crop.circle")
        case .users:
            Label("Users", systemImage: "person.3.fill")
        case .categories:
            Label("Categories", systemImage: "tag.fill")
        }
    }
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .words:
            WordNavigationStack()
        case .users:
            UsersNavigationStack()
        case .categories:
            CategoriesNavigationStack()
        }
    }
}

