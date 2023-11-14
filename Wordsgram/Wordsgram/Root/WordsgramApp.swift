//
//  WordsgramApp.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/03.
//

import SwiftUI

@main
struct WordsgramApp: App {
    let systemServices = SystemServices()
    init() {
        NetworkMonitor.shared.startMonitoring()
        UINavigationBar.appearance().tintColor = UIColor.red
        UITabBar.appearance().tintColor = UIColor.red
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .modifier(systemServices)
        }
    }
}
