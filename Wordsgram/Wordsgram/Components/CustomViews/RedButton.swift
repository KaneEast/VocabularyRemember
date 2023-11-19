//
//  RedButton.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/14.
//

import SwiftUI

struct RedButton: View {
  let title: String
  let action: () -> Void
  
  var body: some View {
    Button(action: action) {
      Text(title)
        .foregroundColor(.primaryRed)
    }
  }
}
