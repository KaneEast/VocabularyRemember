////
////  MyTabView.swift
////  Wordsgram
////
////  Created by Kane on 2023/11/03.
////
//
//import SwiftUI
//
//enum Tabs: Codable, Hashable, Identifiable, CaseIterable {
//  case words
//  case categories
//  case books
//  case users
//  case genre
//  case settings
//  
//  var id: Tabs { self }
//}
//
//extension Tabs {
//  @ViewBuilder
//  var label: some View {
//    switch self {
//    case .words:
//      Label("words", systemImage: "pencil.circle.fill")
//    case .categories:
//      Label("Categories", systemImage: "printer.filled.and.paper")
//    case .books:
//      Label("Books", systemImage: "book.pages.fill")
//    case .users:
//      Label("Users", systemImage: "person.3.fill")
//    case .genre:
//      Label("Genre", systemImage: "books.vertical.fill")
//    case .settings:
//      Label("Settings", systemImage: "gearshape.fill")
//    }
//  }
//  
//  @MainActor @ViewBuilder
//  var destination: some View {
//    switch self {
//    case .words:
//      WordsView()
//    case .categories:
//      CategoriesView()
//    case .books:
//      BookListView()
//    case .users:
//      UsersView()
//    case .genre:
//      GenreListView()
//    case .settings:
//      SettingsView()
//    }
//  }
//}
//
//struct MyTabView: View {
//  @Binding var selection: Tabs?
//  @EnvironmentObject var appState: AppState
//  
//  var tabs: [Tabs] {
//    appState.isNoUser ? [.books, .genre, .settings] : Tabs.allCases
//  }
//  
//  var body: some View {
//    SwiftUI.TabView(selection: $selection) {
//      ForEach(tabs) { screen in
//        screen.destination
//          .tag(screen as Tabs?)
//          .tabItem { screen.label }
//      }
//    }
////    .task {
////      if AuthService.shared.isLoggedIn {
////        SystemServices.fetch()
////      }
////    }
////    .onAppear {
////      guard let urlApp = FileManager.default.urls(for: .applicationSupportDirectory,
////                                                  in: .userDomainMask).last else { return }
////      let url = urlApp.appendingPathComponent("default.store")
////      if FileManager.default.fileExists(atPath: url.path) {
////        print("DataStore is located at \(url.absoluteString)")
////      }
////    }
//  }
//}
//
//#Preview {
//  MyTabView(selection: .constant(.words))
//}
