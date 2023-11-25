//
//  WordsgramApp.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/03.
//

import SwiftUI
import SwiftData

@main
struct WordsgramApp {
  
  @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
  @State private var showAlert = false
  @State private var alertData = AlertData.empty
  
  private var auth: AuthService
  private var words: WordsService
  private var categories: CategoriesService
  private var users: UserService
  
  init() {
    auth = AuthService.shared
    words = WordsService()
    categories = CategoriesService()
    users = UserService()
    
    NetworkMonitor.shared.startMonitoring()
    applyStyle()
  }
}

// MARK: - SwiftUI.App
extension WordsgramApp: App {
  var body: some Scene {
    WindowGroup {
      ZStack {
        Rectangle()
          .fill(Color.background)
          .edgesIgnoringSafeArea(.all)
        RootView()
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
          .accentColor(.primaryRed)
          .modelContainer(ModelContainerManager.shared.sharedModelContainer)
          .environmentObject(auth)
          .environmentObject(AppState())
          .environmentObject(words)
          .environmentObject(categories)
          .environmentObject(users)
          .environmentObject(BookCoordinator(bookClient: BookClient(),
                                             bookRepository: ModelRepository<Book>(context: ModelContainerManager.shared.sharedModelContainer.mainContext)))
          .environmentObject(WordCoordinator(repository: ModelRepository<NewWord>(context: ModelContainerManager.shared.sharedModelContainer.mainContext)))
          .environmentObject(GenreCoordinator(repository: ModelRepository<Genre>(context: ModelContainerManager.shared.sharedModelContainer.mainContext)))
#if DEBUG
        //.modelContainer(TheApp.previewModelContainer)
#endif
      }
    }
  }
}
