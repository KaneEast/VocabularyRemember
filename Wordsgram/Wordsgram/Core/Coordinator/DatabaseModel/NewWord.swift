//
//  NewWord.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/21.
//

import Foundation
import SwiftData

@Model
public final class NewWord {
  var word: String
  var book: Book?
  
  init(word: String, book: Book? = nil) {
    self.word = word
    self.book = book
  }
}
