//
//  TheApp.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/03.
//

import SwiftUI
import SwiftData

@main
struct App {
  typealias Objects = (
    auth: AuthService,
    appState: AppState,
    words: WordsService,
    categories: CategoriesService,
    users: UserService
  )
  
  @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
  
  private var auth: AuthService
  private var appState: AppState
  private var words: WordsService
  private var categories: CategoriesService
  private var users: UserService
  
  @State private var showAlert = false
  @State private var alertData = AlertData.empty
  
  var sharedModelContainer: ModelContainer = {
    let schema = Schema([
      Book.self,
      Note.self,
      Genre.self,
    ])
    let modelConfiguration = ModelConfiguration(schema: schema,
                                                isStoredInMemoryOnly: false)
    
    do {
      return try ModelContainer(for: schema,
                                configurations: [modelConfiguration])
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }()
  
  static var previewModelContainer: ModelContainer {
    let previewSchema = Schema([
      Book.self,
      Note.self,
      Genre.self,
    ])
    let previewConfiguration = ModelConfiguration(schema: previewSchema,
                                                  isStoredInMemoryOnly: true)
    
    do {
      return try ModelContainer(for: previewSchema,
                                configurations: [previewConfiguration])
    } catch {
      fatalError("Could not create Preview ModelContainer: \(error)")
    }
  }
  
  init() {
    let appObjects = App.objects
    auth = appObjects.auth
    appState = appObjects.appState
    words = appObjects.words
    categories = appObjects.categories
    users = appObjects.users
    
    NetworkMonitor.shared.startMonitoring()
    applyStyle()
  }
}

// MARK: - SwiftUI.App
extension App: SwiftUI.App {
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
          .modelContainer(sharedModelContainer)
          .environmentObject(auth)
          .environmentObject(appState)
          .environmentObject(words)
          .environmentObject(categories)
          .environmentObject(users)
          .environmentObject(BookCoordinator(bookClient: BookClient(),
                                             bookRepository: ModelRepository<Book>(context: sharedModelContainer.mainContext)))
          .environmentObject(WordCoordinator(repository: ModelRepository<NewWord>(context: sharedModelContainer.mainContext)))
          .environmentObject(GenreCoordinator(repository: ModelRepository<Genre>(context: sharedModelContainer.mainContext)))
#if DEBUG
        //.modelContainer(TheApp.previewModelContainer)
#endif
      }
    }
  }
}

// MARK: - internal
extension App {
  // Initialise the database
  static var objects: Objects {
    // do some dependency inject
    let appState = AppState()
    let auth = AuthService.shared // TODO: fix this
    let words = WordsService()
    let categories = CategoriesService()
    let users = UserService()
    
    return (
      auth: auth,
      appState: appState,
      words: words,
      categories: categories,
      users: users
    )
  }
}

// MARK: - private
private extension App {
  mutating func startServices() {
    
  }
  
  func customizeNavigationBar() {
    UINavigationBar.appearance().backgroundColor = .backgroundColor
    
    UINavigationBar.appearance().largeTitleTextAttributes = [
      .foregroundColor: UIColor(named: "titleText")!,
      .font: UIFont.uiLargeTitle
    ]
    UINavigationBar.appearance().titleTextAttributes = [
      .foregroundColor: UIColor(named: "titleText")!,
      .font: UIFont.uiHeadline
    ]
  }
  
  func customizeTableView() {
    UITableView.appearance().separatorColor = .clear
    UITableViewCell.appearance().backgroundColor = .backgroundColor
    UITableViewCell.appearance().selectionStyle = .none
    UITableView.appearance().backgroundColor = .backgroundColor
  }
  
  func customizeControls() {
    UISwitch.appearance().onTintColor = .accent
  }
  
  func setupAppReview() {
  }
}
