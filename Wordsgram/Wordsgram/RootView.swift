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
  
  var body: some View {
    if auth.isLoggedIn || appState.isNoUser {
      AppTabView()
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
}

#Preview {
  RootView()
}
