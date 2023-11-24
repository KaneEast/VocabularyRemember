//
//  UIView+FindSubView.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/24.
//

import UIKit
extension UIView {
  func findViews<T: UIView>(subclassOf: T.Type) -> [T] {
    return recursiveSubviews.compactMap { $0 as? T }
  }
  
  var recursiveSubviews: [UIView] {
    return subviews + subviews.flatMap { $0.recursiveSubviews }
  }
}
