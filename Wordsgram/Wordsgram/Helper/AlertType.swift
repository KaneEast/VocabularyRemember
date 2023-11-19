//
//  AlertType.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/12.
//

import SwiftUI

import SwiftUI

enum AlertType: Identifiable {
  case simple
  case confirmation(confirmAction: () -> Void)
  case choice(primaryAction: () -> Void, secondaryAction: () -> Void)
  
  var alert: Alert {
    switch self {
    case .simple:
      return Alert(title: Text("Simple Alert"), message: Text("This is a simple message."), dismissButton: .default(Text("OK")))
      
    case .confirmation(let confirmAction):
      return Alert(
        title: Text("Confirmation Needed"),
        message: Text("Are you sure you want to do this?"),
        primaryButton: .default(Text("Confirm"), action: confirmAction),
        secondaryButton: .cancel()
      )
      
    case .choice(let primaryAction, let secondaryAction):
      return Alert(
        title: Text("Make a Choice"),
        message: Text("Please choose Yes or No."),
        primaryButton: .default(Text("Yes"), action: primaryAction),
        secondaryButton: .default(Text("No"), action: secondaryAction)
      )
    }
  }
  
  var id: String {
    switch self {
    case .simple:
      return "simple"
    case .confirmation:
      return "confirmation"
    case .choice:
      return "choice"
    }
  }
}
