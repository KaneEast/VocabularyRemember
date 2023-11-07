//
//  WordsgramApp.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/03.
//

import SwiftUI

@main
struct WordsgramApp: App {
    init() {
        NetworkMonitor.shared.startMonitoring()
    }
    
    var body: some Scene {
        WindowGroup {
            RootScreen()
                .environmentObject(Auth.shared)
        }
    }
}
