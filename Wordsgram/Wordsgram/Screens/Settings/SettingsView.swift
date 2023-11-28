//
//  HomeScreen.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/03.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
  @EnvironmentObject var authService: AuthService
  @Environment(UserPreferences.self) private var preferences
  @Environment(\.requestReview) var requestReview
  @State var dailyReminderTime = Date(timeIntervalSince1970: 0)
  
  var body: some View {
    @Bindable var userPreferences = preferences
    List {
      Section(header: Text("Appearance")) {
        Picker("", selection: $userPreferences.appearance) {
          ForEach(Appearance.allCases) { appearance in
            Text(appearance.name).tag(appearance)
          }
        }
        .pickerStyle(SegmentedPickerStyle())
      }
      
      Section(header: Text("Notifications")) {
        HStack {
          Toggle("Daily Reminder", isOn: $userPreferences.dailyReminderEnabled)
          DatePicker("", selection: $dailyReminderTime, displayedComponents: .hourAndMinute)
        }
      }
      .onChange(of: userPreferences.dailyReminderEnabled) {
        configureNotification()
      }
      .onChange(of: dailyReminderTime) {
        userPreferences.dailyReminderTimeShadow = dailyReminderTime.timeIntervalSince1970
        configureNotification()
      }
      .onAppear {
        dailyReminderTime = Date(timeIntervalSince1970: userPreferences.dailyReminderTimeShadow)
      }
      
      reLoginButton
      testRequestBookButton
      testShowAlertButton
      appGroupsTestButton
      signOutButton
      testRequestReviewButton
    }
    .navigationTitle("Settings")
  }
  
  func configureNotification() {
    @Bindable var userPreferences = preferences
    if userPreferences.dailyReminderEnabled {
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

extension SettingsView {
  var reLoginButton: some View {
    @Bindable var userPreferences = preferences
    return Button("Re login") {
      userPreferences.isNoUser = false
    }
  }
  
  var testRequestBookButton: some View {
    Button("Test request book") {
      fetchWords()
    }
  }
  
  var testShowAlertButton: some View {
    Button("Test Show alert") {
      NotificationCenter.default.post(
        name: .showAlert,
        object: AlertNotificationObject.error
      )}
  }
  
  var appGroupsTestButton: some View {
    Button("App Groups Test Button") {
      saveCount()
    }
  }
  
  var signOutButton: some View {
    Button("Sign Out") {
      authService.signOut()
    }
  }
  
  var testRequestReviewButton: some View {
    Button("Review our app!") {
      requestReview()
    }
  }
}

#Preview {
    SettingsView()
}
