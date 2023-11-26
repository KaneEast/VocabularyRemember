//
//  AppDelegate.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/20.
//

import UIKit

final class AppDelegate: UIResponder, UIApplicationDelegate {
  
  func application(
    _: UIApplication,
    didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    print("AppDelegate: didFinishLaunchingWithOptions")
    if let urlApp = FileManager.default.urls(for: .applicationSupportDirectory,
                                             in: .userDomainMask).last {
      let url = urlApp.appendingPathComponent("default.store")
      if FileManager.default.fileExists(atPath: url.path) {
        print("DataStore is located at \(url.absoluteString)")
      }
    }
    
    return true
  }
}
