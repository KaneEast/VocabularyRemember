//
//  AsAnyViewModifier.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/18.
//

import SwiftUI
struct AsAnyViewModifier: ViewModifier {
  func body(content: Content) -> some View {
    AnyView(content)
  }
}

extension View {
  func asAnyView() -> some View {
    self.modifier(AsAnyViewModifier())
  }
}
