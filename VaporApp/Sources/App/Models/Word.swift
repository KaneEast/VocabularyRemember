//
//  File.swift
//
//
//  Created by Kane on 2023/11/01.
//

import Vapor
import Fluent

// Define a class that conforms to Model.
final class Word: Model {
    
    // Specify the schema as required by Model. This is the name of the table in the database.
    static let schema = "words"
    
    // Define an optional id property that stores the ID of the model,
    // if one has been set. This is annotated with Fluent’s @ID property wrapper. 
    // This tells Fluent what to use to look up the model in the database.
    
//    @ID
//    var id: UUID?
    
//    @ID var id: UUID?
    @ID(key: .id)
    var id: UUID?
//    @ID(custom: "id", generatedBy: .database) var id: UUID?
//    @ID(custom: .id, generatedBy: .database) var id: UUID?
    
    // Define two String properties to hold the acronym and its definition. These use the @Field property wrapper to denote a generic database field. The key parameter is the name of the column in the database.
    @Field(key: "name")
    var name: String
    
    @Field(key: "meaning")
    var meaning: String
    
    // Provide an empty initializer as required by Model. Fluent uses this to initialize models returned from database queries.
    init() {}
    
    // Provide an initializer to create the model as required.
    init(id: UUID? = nil, name: String, meaning: String) {
        self.id = id
        self.name = name
        self.meaning = meaning
    }
    
//    init(name: String, meaning: String) {
//        self.name = name
//        self.meaning = meaning
//    }
}

extension Word: Content {}