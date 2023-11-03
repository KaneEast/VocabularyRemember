//
//  CreateUser.swift
//
//
//  Created by Kane on 2023/11/02.
//

import Fluent

// Create a new type for the migration to create the users table in the database.
struct CreateUser: Migration {
    // Implement prepare(on:) as required by Migration.
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        // Set up the schema for User with the name of the table as users.
        database.schema("users")
        // Create the ID column using the default properties.
            .id()
        // Create the columns for the two other properties. These are both String and required. The name of the columns match the keys defined in the property wrapper for each property.
            .field("name", .string, .required)
            .field("username", .string, .required)
            .field("password", .string, .required)
            .unique(on: "username")

        // Create the table.
            .create()
    }
    
    // Implement revert(on:) as required by Migration. This deletes the table named users.
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users").delete()
    }
}
