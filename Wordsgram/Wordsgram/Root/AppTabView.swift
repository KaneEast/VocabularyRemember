//
//  AppScreen.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/03.
//

import SwiftUI

enum AppTab: Codable, Hashable, Identifiable, CaseIterable {
    case words
    case categories
    case books
    case users
    case genre
    case settings
    
    var id: AppTab { self }
}

extension AppTab {
    @ViewBuilder
    var label: some View {
        switch self {
        case .words:
            Label("words", systemImage: "pencil.circle.fill")
        case .categories:
            Label("Categories", systemImage: "printer.filled.and.paper")
        case .books:
            Label("Books", systemImage: "printer.filled.and.paper")
        case .users:
            Label("Users", systemImage: "person.3.fill")
        case .genre:
            Label("Genre", systemImage: "person.2.fill")
        case .settings:
            Label("Settings", systemImage: "gearshape.fill")
        }
    }
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .words:
            WordsView()
        case .categories:
            CategoriesView()
        case .books:
            BookListView()
        case .users:
            UsersView()
        case .genre:
            GenreListView()
        case .settings:
            SettingsView()
        }
    }
}

struct AppTabView: View {
    @Binding var selection: AppTab?
    @EnvironmentObject var appState: AppState
    
    var tabs: [AppTab] {
        appState.isNoLoginMode ? [.words, .categories, .books, .genre, .settings] : AppTab.allCases
    }
    
    var body: some View {
        TabView(selection: $selection) {
            ForEach(tabs) { screen in
                screen.destination
                    .tag(screen as AppTab?)
                    .tabItem { screen.label }
            }
            .background(.ultraThinMaterial)
        }
        
        .task {
            if AuthService.shared.isLoggedIn {
                SystemServices.fetch()
            }
        }
    }
}

#Preview {
    AppTabView(selection: .constant(.words))
}
