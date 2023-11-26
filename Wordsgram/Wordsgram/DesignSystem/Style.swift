//
//  Style.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/19.
//

import SwiftUI

func applyStyle() {
  UINavigationBar.appearance().tintColor = UIColor(named: "APrimaryRed")
  UITabBar.appearance().tintColor = UIColor(named: "APrimaryRed")
  
  let appearance = UITabBarAppearance()
  appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
  //appearance.backgroundColor = UIColor(Color.white.opacity(0.1))
  UITabBar.appearance().standardAppearance = appearance
  UITabBar.appearance().scrollEdgeAppearance = appearance
}

func customizeNavigationBar() {
  UINavigationBar.appearance().backgroundColor = .backgroundColor
  
  UINavigationBar.appearance().largeTitleTextAttributes = [
    .foregroundColor: UIColor(named: "titleText")!,
    .font: UIFont.uiLargeTitle
  ]
  UINavigationBar.appearance().titleTextAttributes = [
    .foregroundColor: UIColor(named: "titleText")!,
    .font: UIFont.uiHeadline
  ]
}

func customizeTableView() {
  UITableView.appearance().separatorColor = .clear
  UITableViewCell.appearance().backgroundColor = .backgroundColor
  UITableViewCell.appearance().selectionStyle = .none
  UITableView.appearance().backgroundColor = .backgroundColor
}

func customizeControls() {
  UISwitch.appearance().onTintColor = .accent
}
