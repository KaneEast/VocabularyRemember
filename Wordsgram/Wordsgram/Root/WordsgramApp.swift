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
        systemServices.fetch()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .modifier(systemServices)
        }
    }
}
