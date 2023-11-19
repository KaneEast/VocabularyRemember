//
//  AlertAnywhere.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/16.
//

import SwiftUI

public extension Notification.Name {
  static let showAlert = Notification.Name("showAlert")
}

struct AlertData {
  let title: Text
  let message: Text?
  let dismissButton: Alert.Button?
  
  static let empty = AlertData(title: Text(""),
                               message: nil,
                               dismissButton: nil)
}

enum AlertNotificationObject {
  case success
  case error
  case warning
  
  var notificationName: Notification.Name {
    switch self {
    case .success:
      return .init("showSuccessAlert")
    case .error:
      return .init("showErrorAlert")
    case .warning:
      return .init("showWarningAlert")
    }
  }
  
  var alertData: AlertData {
    switch self {
    case .success:
      return AlertData(title: Text("Success"),
                       message: Text("Operation completed successfully."),
                       dismissButton: .default(Text("OK")))
    case .error:
      return AlertData(title: Text("Error"),
                       message: Text("An error occurred."),
                       dismissButton: .default(Text("OK")))
    case .warning:
      return AlertData(title: Text("Warning"),
                       message: Text("Please be careful."),
                       dismissButton: .default(Text("OK")))
    }
  }
}

