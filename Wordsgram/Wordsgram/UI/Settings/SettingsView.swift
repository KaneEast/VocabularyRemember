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
  @AppStorage("appearance") var appearance: Appearance = .automatic
  @Environment(\.requestReview) var requestReview
  @State var dailyReminderTime = Date(timeIntervalSince1970: 0)
  @AppStorage("dailyReminderEnabled") var dailyReminderEnabled = false
  @AppStorage("dailyReminderTime") var dailyReminderTimeShadow: Double = 0
  
  var body: some View {
    //NavigationStack {
      List {
        Section(header: Text("Appearance")) {
//          VStack(alignment: .leading) {
            Picker("", selection: $appearance) {
              ForEach(Appearance.allCases) { appearance in
                Text(appearance.name).tag(appearance)
              }          }
            .pickerStyle(SegmentedPickerStyle())
//          }
        }
        
        Section(header: Text("Notifications")) {
          HStack {
            Toggle("Daily Reminder", isOn: $dailyReminderEnabled)
            DatePicker("", selection: $dailyReminderTime, displayedComponents: .hourAndMinute)
          }
        }
        .onChange(of: dailyReminderEnabled) {
          configureNotification()
        }
        .onChange(of: dailyReminderTime) {
          dailyReminderTimeShadow = dailyReminderTime.timeIntervalSince1970
          configureNotification()
        }
        .onAppear {
          dailyReminderTime = Date(timeIntervalSince1970: dailyReminderTimeShadow)
        }
        
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
      
      .navigationTitle("Settings")
    //}
  }
  
  func configureNotification() {
    if dailyReminderEnabled {
      LocalNotifications.shared.createReminder(time: dailyReminderTime)
    } else {
      LocalNotifications.shared.deleteReminder()
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


#Preview {
  Group {
    SettingsView()
    SettingsView()
      .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
  }
}
