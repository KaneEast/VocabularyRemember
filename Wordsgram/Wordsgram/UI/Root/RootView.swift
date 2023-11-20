//
//  RootView.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/03.
//

import SwiftUI

struct RootView: View {
  @EnvironmentObject var auth: AuthService
  @EnvironmentObject var appState: AppState
  private let tabViewModel = TabViewModel()
  init() {}
  
  var body: some View {
    if auth.isLoggedIn || appState.isNoUser {
      tabBarView
        .task {
          if AuthService.shared.isLoggedIn {
            SystemServices.fetch()
          }
        }
        .onAppear {
          guard let urlApp = FileManager.default.urls(for: .applicationSupportDirectory,
                                                      in: .userDomainMask).last else { return }
          let url = urlApp.appendingPathComponent("default.store")
          if FileManager.default.fileExists(atPath: url.path) {
            print("DataStore is located at \(url.absoluteString)")
          }
        }
    } else {
      LoginView()
    }
  }
  
  @ViewBuilder var tabBarView: some View {
    TabView(
      booklistView: BookListView.init,
      genreListView: GenreListView.init,
      settingsView: settingsView
    )
    .environmentObject(tabViewModel)
  }
  
  //  func downloadsView() -> DownloadsView {
  //    .init(
  //      contentScreen: .downloads(permitted: sessionController.user?.canDownload ?? false),
  //      downloadRepository: dataManager.downloadRepository
  //    )
  //  }
  
  func settingsView() -> SettingsView {
    .init()
    //init(settingsManager: settingsManager)
  }
}

#Preview {
  RootView()
}
