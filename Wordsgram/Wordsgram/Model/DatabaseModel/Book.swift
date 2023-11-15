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
    
    /// This property is marked optional because we are adding a new attribute to our existing app and previously
    /// saved data should not be affected with this change as long as we are either adding new property as optional or with a default value.
    
    /// Images are large and its not a good idea to store them in the data store directly(Due to performance issues), 
    /// we can opt to store only the reference of the image and actual data for the image can be located somewhere else on the disk.
    /// We don’t have to do any of that manually as well, we can leverage SwiftData’s Attribute macro and
    /// define the schema configuration to store image’s binary data externally.
    
    @Attribute(.externalStorage)
    var cover: Data?
    
    init(title: String, author: String, publishedYear: Int) {
        self.title = title
        self.author = author
        self.publishedYear = publishedYear
    }
}


