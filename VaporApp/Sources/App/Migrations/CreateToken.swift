//
//  File.swift
//
//
//  Created by Kane on 2023/11/03.
//

import Fluent

/// Like other migrations before, this creates the table for Token. It also creates a reference to User for the userID field. The reference is marked with a cascade deletion so that any tokens are automatically deleted when you delete a user.
struct CreateToken: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("tokens")
            .id()
            .field("value", .string, .required)
            .field(
                "userID",
                .uuid,
                .required,
                .references("users", "id", onDelete: .cascade))
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("tokens").delete()
    }
}

