//
//  WordCoordinator.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/24.
//

import SwiftUI

class WordCoordinator: ObservableObject {
  //var bookClient: BookClient = BookClient()
  var repository: ModelRepository<NewWord>
  
  @Published var searchTerm: String = ""
  
  init(repository: ModelRepository<NewWord>) {
    //self.bookClient = bookClient
    self.repository = repository
  }
  
  func create(words: [NewWord]) throws {
    try repository.create(words)
    // check network
    //bookClient.create()
  }
  
  func deldete(words: [NewWord]) throws {
    try repository.deleteEntities(words)
    // check network
    //bookClient.delete()
  }
  
  func save() throws {
    try repository.save()
  }
}

