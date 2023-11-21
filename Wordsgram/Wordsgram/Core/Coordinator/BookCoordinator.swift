//
//  BookCoordinator.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/20.
//

import SwiftUI

class BookCoordinator: ObservableObject {
  var bookClient: BookClient = BookClient()
  var bookRepository: ModelRepository<Book>
  
  @Published var searchTerm: String = ""
  
  init(bookClient: BookClient, bookRepository: ModelRepository<Book>) {
    self.bookClient = bookClient
    self.bookRepository = bookRepository
  }
  
  func create(books: [Book]) throws {
    try bookRepository.create(books)
    
    // check network
    //bookClient.create()
    
  }
  func deldete(books: [Book]) throws {
    try bookRepository.deleteEntities(books)
    // check network
    //bookClient.delete()
  }
  
  func save() throws {
    try bookRepository.save()
  }
  
  // func update
  // func sync with remote
  
  //    func sync(_ remotePosts: [Book]) async {
  //        do {
  //            // load local posts
  //            var localPosts = try repository.getAll()
  //
  //            // first delete stale posts
  //            let postsToDelete = checkPostsForDeletion(localPosts: localPosts, remotePosts: remotePosts)
  //            repository.deleteEntities(postsToDelete)
  //            updateLocalPosts(with: remotePosts, in: &localPosts)
  //            repository.create(remotePosts)
  //            try repository.save()
  //        } catch {
  //            print(error.localizedDescription)
  //        }
  //    }
  //
  //    func updateLocalPosts(with remotePosts: [Book], in localPosts: inout [Book]) {
  //        for (index, localPost) in localPosts.enumerated() {
  //            if let matchingRemotePost = remotePosts.first(where: { $0.id == localPost.id }),
  //               localPost != matchingRemotePost
  //            {
  //                localPosts[index] = matchingRemotePost
  //            }
  //        }
  //    }
  //
  //    private func checkPostsForDeletion(localPosts: [Book], remotePosts: [Book]) -> [Book] {
  //        var postsToDelete: [Book] = []
  //
  //        let remotePostIds = Set(remotePosts.map { $0.id })
  //
  //        for localPost in localPosts {
  //            if !remotePostIds.contains(localPost.id) {
  //                postsToDelete.append(localPost)
  //            }
  //        }
  //
  //        return postsToDelete
  //    }
}
