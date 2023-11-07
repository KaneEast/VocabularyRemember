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
    case settings
    
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
        case .settings:
            Label("Settings", systemImage: "gear")
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
        case .settings:
            HomeScreen()
        }
    }
}

struct AppTabView: View {
    @Binding var selection: AppScreen?
    @EnvironmentObject var auth: Auth
    
    var body: some View {
        TabView(selection: $selection) {
            ForEach(AppScreen.allCases) { screen in
                screen.destination
                    .tag(screen as AppScreen?)
                    .tabItem { screen.label }
            }
        }
    }
}

#Preview {
    AppTabView(selection: .constant(.words))
}
