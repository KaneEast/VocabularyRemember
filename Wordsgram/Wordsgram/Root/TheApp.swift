//
//  TheApp.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/03.
//

import SwiftUI
import SwiftData

@main
struct TheApp: App {
  @State private var showAlert = false
  @State private var alertData = AlertData.empty
  
  var sharedModelContainer: ModelContainer = {
    let schema = Schema([
      Book.self,
      Note.self,
      Genre.self,
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
    
    do {
      return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }()
  
  init() {
    NetworkMonitor.shared.startMonitoring()
    applyStyle()
  }
  
  var body: some Scene {
    WindowGroup {
      RootView()
        .modifier(SystemServices())
        .onReceive(NotificationCenter.default.publisher(for: .showAlert)) { notif in
          // Show Alert Anywhere
          if let data = notif.object as? AlertNotificationObject {
            alertData = data.alertData
            showAlert = true
          }
        }
        .alert(isPresented: $showAlert) {
          Alert(title: alertData.title,
                message: alertData.message,
                dismissButton: alertData.dismissButton)
        }
    }
    .modelContainer(sharedModelContainer)
    .environmentObject(BookProvider(context: sharedModelContainer.mainContext))
    .environmentObject(GenreProvider(context: sharedModelContainer.mainContext))
  }
}
