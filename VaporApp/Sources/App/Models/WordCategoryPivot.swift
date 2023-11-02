//
//  WordCategoryPivot.swift
//
//
//  Created by Kane on 2023/11/02.
//

import Fluent
import Foundation

// Define a new object WordCategoryPivot that conforms to Model.
final class WordCategoryPivot: Model {
    static let schema = "word-category-pivot"
    
    // Define an id for the model. Note this is a UUID type so you must import the Foundation module.
    @ID
    var id: UUID?
    
    // Define two properties to link to the Word and Category. You annotate the properties with the @Parent property wrapper. A pivot record can point to only one Word and one Category, but each of those types can point to multiple pivots.
    @Parent(key: "wordID")
    var word: Word
    
    @Parent(key: "categoryID")
    var category: Category
    
    // Implement the empty initializer, as required by Model
    init() {}
    
    // Implement an initializer that takes the two models as arguments. This uses requireID() to ensure the models have an ID set.
    init(id: UUID? = nil, word: Word, category: Category) throws {
        self.id = id
        self.$word.id = try word.requireID()
        self.$category.id = try category.requireID()
    }
}
