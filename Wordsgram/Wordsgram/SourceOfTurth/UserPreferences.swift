//
//  UserPreferences.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/27.
//

import Combine
import Foundation
import SwiftUI

public enum Appearance: Int, CaseIterable, Identifiable {
  case light, dark, automatic

  public var id: Int { rawValue }

  var name: String {
    switch self {
    case .light: return "Light"
    case .dark: return "Dark"
    case .automatic: return "Automatic"
    }
  }
  
  func getColorScheme() -> ColorScheme? {
    switch self {
    case .automatic: return nil
    case .light: return .light
    case .dark: return .dark
    }
  }
}

@MainActor
@Observable public class UserPreferences {
  class Storage {
    @AppStorage("appearance") var appearance: Appearance = .automatic
    @AppStorage("requested_review") public var requestedReview = false
    @AppStorage("dailyReminderEnabled") public var dailyReminderEnabled = false
    @AppStorage("dailyReminderTime") public var dailyReminderTimeShadow: Double = 0
    @AppStorage("isNoLoginMode") var isNoUser = false
  }
  
  public static let shared = UserPreferences()
  private let storage = Storage()
  
  private init() {
    appearance = storage.appearance
    requestedReview = storage.requestedReview
    dailyReminderEnabled = storage.dailyReminderEnabled
    dailyReminderTimeShadow = storage.dailyReminderTimeShadow
    isNoUser = storage.isNoUser
  }
  
  public var appearance: Appearance {
    didSet {
      storage.appearance = appearance
    }
  }
  
  public var requestedReview: Bool {
    didSet {
      storage.requestedReview = requestedReview
    }
  }
  
  
  
  public var dailyReminderEnabled: Bool {
    didSet {
      storage.dailyReminderEnabled = dailyReminderEnabled
    }
  }
  
  public var dailyReminderTimeShadow: Double {
    didSet {
      storage.dailyReminderTimeShadow = dailyReminderTimeShadow
    }
  }
  
  public var isNoUser: Bool {
    didSet {
      storage.isNoUser = isNoUser
    }
  }
}
