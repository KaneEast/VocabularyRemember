//
//  File.swift
//
//
//  Created by Kane on 2023/11/01.
//

import Fluent

// Define a new type, CreateWord that conforms to Migration.
struct CreateWord: Migration {
    // Implement prepare(on:) as required by Migration. You call this method when you run your migrations.
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        // Define the table name for this model. This must match schema from the model.
        database.schema("words")
            // Define the ID column in the database.
            .id()
            // Define columns for name and meaning. Set the column type to string and mark the columns as required. This matches the non-optional String properties in the model. The field names must match the key of the property wrapper, not the name of the property itself.
            .field("name", .string, .required)
            .field("meaning", .string, .required)
            .field("userID", .uuid, .required, .references("users", "id")) // Foreign key
            .unique(on: "name")
            .create() // Create the table in the database.
    }
    
    // Implement revert(on:) as required by Migration. You call this function when you revert your migrations. This deletes the table referenced with schema(_:).
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("words").delete()
    }
}

