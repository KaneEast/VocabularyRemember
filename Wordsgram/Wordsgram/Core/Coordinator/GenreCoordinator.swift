//
//  GenreCoordinator.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/24.
//

import SwiftUI

class GenreCoordinator: ObservableObject {
  //var bookClient: BookClient = BookClient()
  var repository: ModelRepository<Genre>
  
  @Published var searchTerm: String = ""
  
  init(repository: ModelRepository<Genre>) {
    //self.bookClient = bookClient
    self.repository = repository
  }
  
  func create(items: [Genre]) throws {
    try repository.create(items)
    // check network
    //bookClient.create()
  }
  
  func deldete(_ items: [Genre]) throws {
    try repository.deleteEntities(items)
    // check network
    //bookClient.delete()
  }
  
  func save() throws {
    try repository.save()
  }
}


