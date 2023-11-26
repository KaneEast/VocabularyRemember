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
    } else {
      LoginView()
    }
  }
}

#Preview {
  RootView()
}
