//
//  RootView.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/03.
//

import SwiftUI

struct RootView: View {
  @EnvironmentObject var auth: AuthService
  @Environment(UserPreferences.self) private var preferences
  
  var body: some View {
    if auth.isLoggedIn || preferences.isNoUser {
      AppTabView()
    } else {
      LoginView()
    }
  }
}

#Preview {
  RootView()
}
