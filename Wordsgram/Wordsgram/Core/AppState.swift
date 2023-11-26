//
//  AppState.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/12.
//

import SwiftUI
import Observation

class AppState: ObservableObject {
  @AppStorage("isNoLoginMode") var isNoUser = false
  @Published var selectedTab: AppTab = .words
}
