//
//  TabViewModel.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/21.
//

import Combine
import SwiftUI

final class TabViewModel: ObservableObject {
  enum MainTab {
    case books
    case genres
    case settings
  }

  /// An ID that tells a scroll view proxy what view to scroll to when tapping an already-selected tab.
  struct ScrollToTopID {
    let mainTab: MainTab
    let detail: Bool
  }

  @Published var selectedTab: MainTab = .books

  var showingDetailView = Dictionary(
    uniqueKeysWithValues: zip(MainTab.allCases, AnyIterator { false })
  )
}

// MARK: - CaseIterable
extension TabViewModel.MainTab: CaseIterable { }

// MARK: - Environment
extension TabViewModel.MainTab: EnvironmentKey {
  static var defaultValue: Self { .books }
}

extension EnvironmentValues {
  var mainTab: TabViewModel.MainTab {
    get { self[TabViewModel.MainTab.self] }
    set { self[TabViewModel.MainTab.self] = newValue }
  }
}

// MARK: - Hashable
extension TabViewModel.ScrollToTopID: Hashable { }

