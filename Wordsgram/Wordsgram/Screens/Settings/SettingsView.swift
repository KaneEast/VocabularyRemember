//
//  HomeScreen.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/03.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
  @EnvironmentObject var appState: AppState
  @EnvironmentObject var authService: AuthService
  @Environment(\.requestReview) var requestReview
  
  var body: some View {
    NavigationStack {
      VStack(spacing: 20) {
        SettingsList()
        
        Spacer()
        
        Button("Re login") {
          appState.isNoUser = false
        }
        
        Button("Test request book") {
          fetchWords()
        }
        
        Button("Review our app!") {
          requestReview()
        }
        
        Button("Test Show alert") {
          NotificationCenter.default.post(
            name: .showAlert,
            object: AlertNotificationObject.error
          )}
        
        Button("App Groups Test Button") {
          saveCount()
        }
        Button("Sign Out") {
          authService.signOut()
        }
      }
      .padding(20)
      .navigationTitle("Settings")
    }
  }
  
  private func saveCount() {
    UserDefaultsHelper.persistRecords(1)
  }
  
  func fetchWords() {
  }
}

struct HomeScreen_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}

struct SettingsList: View {
  var body: some View {
    VStack(spacing: 0) {
      ForEach(SettingsOption.allCases) { self[$0] }
    }
  }
}

private extension SettingsList {
  @ViewBuilder subscript(option: SettingsOption) -> some View {
    switch option {
    case .settings1:
      SettingsDisclosureRow(title: option.title, value: "")
    case .settings2:
      SettingsDisclosureRow(title: option.title, value: "")
    case .settings3:
      NavigationLink(destination: CountryListView()) {
        SettingsDisclosureRow(title: option.title, value: "")
      }
    case .libraries:
      NavigationLink(destination: EmptyView()) {
        SettingsDisclosureRow(title: option.title, value: "")
      }
    }
  }
}

#Preview {
  Group {
    SettingsView()
    SettingsView()
      .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
  }
}
