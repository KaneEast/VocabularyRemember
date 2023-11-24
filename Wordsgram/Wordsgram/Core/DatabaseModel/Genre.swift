//
//  Genre.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/14.
//

import Foundation
import SwiftData

@Model
public final class Genre {
  var name: String
  var books = [Book]()
  
  init(name: String) {
    self.name = name
  }
}
