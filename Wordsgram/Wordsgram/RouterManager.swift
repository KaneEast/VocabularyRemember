//
//  RouterManager.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/28.
//

import Foundation
import Observation

@MainActor @Observable
class RouterManager {
  static let shared = RouterManager()
  var bookTabRouter = RouterPath()
  var genreTabRouter = RouterPath()
  
  
  func handleDeepLink(url: URL) {
    // 解析URL，并更新对应Tab的RouterPath
    // 例如，如果URL指向特定书籍，则更新bookTabRouter
  }
}
