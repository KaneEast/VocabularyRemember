//
//  MainButtonView.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/09.
//

import SwiftUI

enum MainButtonType {
  case primary(withArrow: Bool)
  case secondary(withArrow: Bool)
  case destructive(withArrow: Bool)
  
  var color: Color {
    switch self {
    case .primary:
      return .primaryRed
    case .secondary:
      return .cyan
    case .destructive:
      return .secondaryPink
    }
  }
  
  var hasArrow: Bool {
    switch self {
    case
        .primary(let hasArrow),
        .destructive(let hasArrow),
        .secondary(let hasArrow):
      return hasArrow
    }
  }
}

struct MainButtonView: View {
  private struct SizeKey: PreferenceKey {
    static func reduce(value: inout CGSize?, nextValue: () -> CGSize?) {
      value = value ?? nextValue()
    }
  }
  
  @State private var height: CGFloat?
  var title: String
  var type: MainButtonType
  var callback: () -> Void
  
  var body: some View {
    Button {
      callback()
    } label: {
      HStack {
        ZStack(alignment: .center) {
          HStack {
            Spacer()
            
            Text(title)
              .font(.subheadline)
              .foregroundColor(.orange)
              .padding(15)
              .background(GeometryReader { proxy in
                Color.clear.preference(key: SizeKey.self, value: proxy.size)
              })
            
            Spacer()
          }
          
          if type.hasArrow {
            HStack {
              Spacer()
              
              Image(systemName: "arrow.right")
                .font(.system(size: 14, weight: .bold))
                .frame(width: height, height: height)
                .foregroundColor(type.color)
                .background(
                  Color.white
                    .cornerRadius(9)
                    .padding(12)
                )
            }
          }
        }
        .frame(height: height)
        .background(
          RoundedRectangle(cornerRadius: 9)
            .stroke(Color.white, lineWidth: 1)
          // Kodeco Reskin skips .fill(type.color)
        )
        .onPreferenceChange(SizeKey.self) { size in
          height = size?.height
        }
      }
    }
  }
}

struct PrimaryButtonView_Previews: PreviewProvider {
  static var previews: some View {
    VStack(spacing: 20) {
      MainButtonView(title: "Got It!", type: .primary(withArrow: false), callback: {})
      MainButtonView(title: "Got It!", type: .primary(withArrow: true), callback: {})
      MainButtonView(title: "Got It!", type: .secondary(withArrow: false), callback: {})
      MainButtonView(title: "Got It!", type: .secondary(withArrow: true), callback: {})
      MainButtonView(title: "Got It!", type: .destructive(withArrow: false), callback: {})
      MainButtonView(title: "Got It!", type: .destructive(withArrow: true), callback: {})
    }
    .padding(20)
    //        .background(Color.background)
    //        .inAllColorSchemes
  }
}

