//
//  WordsgramApp.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/03.
//

import SwiftUI
import SwiftData

@main
struct VocabularyApp {
  @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate 
  @State private var showAlert = false
  @State private var alertData = AlertData.empty
  
  @State private var userPreferences = UserPreferences.shared
  @State private var auth = AuthService.shared
  @State private var words = WordsService()
  @State private var categories = CategoriesService()
  @State private var users = UserService()
  @State private var bookCoordinator = BookCoordinator(bookClient: BookClient(),
                                                       bookRepository: ModelRepository<Book>(
                                                        context: ModelContainerManager.sharedMainContext))
  @State private var wordCoordinator = WordCoordinator(repository:
                                                        ModelRepository<NewWord>(
                                                          context: ModelContainerManager.sharedMainContext))
  @State private var genreCoordinator = GenreCoordinator(repository:
                                                          ModelRepository<Genre>(
                                                            context: ModelContainerManager.sharedMainContext))
  init() {
    NetworkMonitor.shared.startMonitoring()
    applyStyle()
  }
}

// MARK: - SwiftUI.App
extension VocabularyApp: App {
  var body: some Scene {
    WindowGroup {
      ZStack {
        Rectangle()
          .fill(Color.background)
          .edgesIgnoringSafeArea(.all)
          .accessibility(identifier: "BackgroundFirstRectangle")
        
        RootView()
          .modifier(AlertModifier(showAlert: $showAlert, alertData: $alertData))
          .accentColor(.primaryRed)
          .modelContainer(ModelContainerManager.shared.sharedModelContainer)
          .environmentObject(auth)
          .environmentObject(words)
          .environmentObject(categories)
          .environment(userPreferences)
          .environmentObject(users)
          .environmentObject(bookCoordinator)
          .environmentObject(wordCoordinator)
          .environmentObject(genreCoordinator)
          //.preferredColorScheme(appearance.getColorScheme())
          .preferredColorScheme(userPreferences.appearance.getColorScheme())
      }
    }
  }
}

struct AlertModifier: ViewModifier {
  @Binding var showAlert: Bool
  @Binding var alertData: AlertData
  
  func body(content: Content) -> some View {
    content
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
}
