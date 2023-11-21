//
//  DictView.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/21.
//

import SwiftUI

struct DictionaryView: UIViewControllerRepresentable {
  let word: String
  let vc: UIReferenceLibraryViewController
  init(word: String) {
    self.word = word
    self.vc = UIReferenceLibraryViewController(term: word)
  }
  
  func makeUIView(context: Context) -> some UIView {
    
    let uiLayoutContainerView = vc.view.findViews(subclassOf: UIView.self)
    print("----------------------------------------------------------------------------------------")
    print(uiLayoutContainerView.map {
      if let label = $0 as? UILabel? {
        print(label?.text ?? "")
      }
    }
    )
    
    return vc.view
  }
  
  func makeUIViewController(context: UIViewControllerRepresentableContext<DictionaryView>) -> UIReferenceLibraryViewController {
    //printall()
    return vc
  }
  
  func printall() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
      vc.view.findViews(subclassOf: UIView.self).forEach {
        if let label = $0 as? UILabel {
          print("=======================")
          print(label.text ?? "")
        }
      }
    }
  }
  
  func updateUIViewController(_ uiViewController: UIReferenceLibraryViewController, context: UIViewControllerRepresentableContext<DictionaryView>) {
  }
}

extension UIView {
  func findViews<T: UIView>(subclassOf: T.Type) -> [T] {
    return recursiveSubviews.compactMap { $0 as? T }
  }
  
  var recursiveSubviews: [UIView] {
    return subviews + subviews.flatMap { $0.recursiveSubviews }
  }
}
