//
//  RootView.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/03.
//

import SwiftUI

struct RootView: View {
  @State private var selection: Tabs? = .books
  @EnvironmentObject var auth: AuthService
  @EnvironmentObject var appState: AppState
  init() {}
  
  var body: some View {
    if auth.isLoggedIn || appState.isNoUser {
      MyTabView(selection: $selection)
    } else {
      LoginView()
    }
  }
}

#Preview {
  RootView()
}
