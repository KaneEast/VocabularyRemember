//
//  Category.swift
//
//
//  Created by Kane on 2023/11/02.
//

import Fluent
import Vapor

final class Category: Model, Content {
    static let schema = "categories"
    
    @ID
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Siblings(
      through: WordCategoryPivot.self,
      from: \.$category,
      to: \.$word)
    var acronyms: [Word]

    
    init() {}
    
    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}

