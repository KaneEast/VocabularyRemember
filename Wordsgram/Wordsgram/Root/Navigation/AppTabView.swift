//
//  AppTabView.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/03.
//

import SwiftUI

struct AppTabView: View {
    @Binding var selection: AppScreen?
    
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
//        .backyardBirdsDataContainer(inMemory: true)
}
