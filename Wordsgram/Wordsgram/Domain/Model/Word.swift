//
//  Word.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/03.
//

import Foundation

final class Word: Codable {
  var id: UUID?
  var name: String
  var meaning: String
  var user: WordUser

  init(name: String, meaning: String, userID: UUID) {
    self.name = name
    self.meaning = meaning
    let user = WordUser(id: userID)
    self.user = user
  }
}

final class WordUser: Codable {
  var id: UUID

  init(id: UUID) {
    self.id = id
  }
}
