////
////  SystemServices.swift
////  Wordsgram
////
////  Created by Kane on 2023/11/09.
////
//
//import SwiftUI
//import SwiftData
//
//struct SystemServices: ViewModifier {
//  var sharedModelContainer: ModelContainer = {
//    let schema = Schema([
//      Book.self,
//      Note.self,
//      Genre.self,
//    ])
//    let modelConfiguration = ModelConfiguration(schema: schema,
//                                                isStoredInMemoryOnly: false)
//    
//    do {
//      return try ModelContainer(for: schema,
//                                configurations: [modelConfiguration])
//    } catch {
//      fatalError("Could not create ModelContainer: \(error)")
//    }
//  }()
//  
//  static var previewModelContainer: ModelContainer {
//    let previewSchema = Schema([
//      Book.self,
//      Note.self,
//      Genre.self,
//    ])
//    let previewConfiguration = ModelConfiguration(schema: previewSchema,
//                                                  isStoredInMemoryOnly: true)
//    
//    do {
//      return try ModelContainer(for: previewSchema,
//                                configurations: [previewConfiguration])
//    } catch {
//      fatalError("Could not create Preview ModelContainer: \(error)")
//    }
//  }
//  
//  private static var appState     = AppState()
//  private static var auth         = AuthService.shared
//  private static var words        = WordsService()
//  private static var categories   = CategoriesService()
//  private static var users        = UserService()
//  
//  func body(content: Content) -> some View {
//    content
//      .accentColor(.primaryRed)
//      .modelContainer(sharedModelContainer)
//      .environmentObject(Self.auth)
//      .environmentObject(Self.appState)
//      .environmentObject(Self.words)
//      .environmentObject(Self.categories)
//      .environmentObject(Self.users)
//      .environmentObject(BookCoordinator(bookClient: BookClient(),
//                                         bookRepository: ModelRepository<Book>(context: sharedModelContainer.mainContext))
//      )
//#if DEBUG
//    //.modelContainer(TheApp.previewModelContainer)
//#endif
//  }
//  
//  static func fetch() {
//    Task {
//      do {
//        async let fetchWords: ()          = SystemServices.words.fetchAllFromServer()
//        async let fetchCategories: ()     = SystemServices.categories.fetchAllFromServer()
//        async let fetchMoreCategories: () = SystemServices.categories.fetchCategories()
//        async let fetchUsers: ()          = SystemServices.users.fetchAllFromServer()
//        
//        _ = try await [fetchWords, fetchCategories, fetchMoreCategories, fetchUsers]
//      } catch {
//        print("An error occurred: \(error)")
//      }
//    }
//  }
//}
