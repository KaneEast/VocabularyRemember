//
//  CreateWordData.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/03.
//

import Foundation

struct CreateWordData: Codable {
  let name: String
  let meaning: String
  let userID: UUID
}

extension Word {
  func toCreateData() -> CreateWordData {
    CreateWordData(name: self.name, meaning: self.meaning, userID: self.user.id)
  }
}
