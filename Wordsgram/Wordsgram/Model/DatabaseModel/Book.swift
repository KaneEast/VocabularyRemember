//
//  Book.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/14.
//

import Foundation
import SwiftData

// TODO: needs to define what columns is unique

@Model
final class Book {
    var title: String
    var author: String
    var publishedYear: Int
    
    /// Notice that we are setting deleteRule for this relationship as cascade which indicates that upon deleting this book any related models will be deleted as well.
    /// Other delete rules include:
    
    /// noAction: A rule that doesn’t make changes to the related models.
    /// nullify: A rule that nullifies its related model’s reference.
    /// deny: A rule that prevents the deletion of a model because it contains one or more references to the other models
    /// cascade: A rule that deletes any related models.
    @Relationship(deleteRule: .cascade, inverse: \Note.book)
    var notes = [Note]()
    
    @Relationship(deleteRule: .nullify, inverse: \Genre.books)
    var genres = [Genre]()
    
    init(title: String, author: String, publishedYear: Int) {
        self.title = title
        self.author = author
        self.publishedYear = publishedYear
    }
}


