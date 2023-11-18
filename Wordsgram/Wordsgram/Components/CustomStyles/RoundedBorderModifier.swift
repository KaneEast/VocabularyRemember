//
//  CheckboxToggleStyle.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/18.
//

import SwiftUI

struct RoundedBorderModifier: ViewModifier {
    var color: Color = .gray
    var width: CGFloat = 1
    var cornerRadius: CGFloat = 10

    func body(content: Content) -> some View {
        content
        .padding(4)  // 添加内边距
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(color, lineWidth: width)
            )
    }
}

extension View {
    func roundedBorderStyle(color: Color = .gray, width: CGFloat = 1, cornerRadius: CGFloat = 10) -> some View {
        self.modifier(RoundedBorderModifier(color: color, width: width, cornerRadius: cornerRadius))
    }
}
