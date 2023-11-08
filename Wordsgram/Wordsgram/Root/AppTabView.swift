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
    case users
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
        case .users:
            Label("Users", systemImage: "person.3.fill")
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
        case .users:
            UsersView()
        case .settings:
            SettingsView()
        }
    }
}

struct AppTabView: View {
    @Binding var selection: AppTab?
    @EnvironmentObject var auth: Auth
    
    var body: some View {
        TabView(selection: $selection) {
            ForEach(AppTab.allCases) { screen in
                screen.destination
                    .tag(screen as AppTab?)
                    .tabItem { screen.label }
            }
        }
    }
}

#Preview {
    AppTabView(selection: .constant(.words))
}
