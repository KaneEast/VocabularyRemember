//
//  DictView.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/21.
//

import SwiftUI

struct DictionaryView: UIViewControllerRepresentable {
  let word: String
  init(word: String) {
    self.word = word
  }
  
  func makeUIViewController(
    context: UIViewControllerRepresentableContext<DictionaryView>) -> UIReferenceLibraryViewController
  {
    return UIReferenceLibraryViewController(term: word)
  }
  
  func updateUIViewController(_ uiViewController: UIReferenceLibraryViewController, context: UIViewControllerRepresentableContext<DictionaryView>) {
    
  }
}
