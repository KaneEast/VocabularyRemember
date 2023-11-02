//
//  CreateWordCategoryPivot.swift
//
//
//  Created by Kane on 2023/11/02.
//

import Fluent

// Define a new type, CreateAcronymCategoryPivot that conforms to Migration
struct CreateWordCategoryPivot: Migration {
    // Implement prepare(on:) as required by Migration.
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        // Select the table using the schema name defined for WordCategoryPivot.
        database.schema("word-category-pivot")
            // Create the ID column.
            .id()
            // Create the two columns for the two properties.
            // These use the key provided to the property wrapper, set the type to UUID,
            // and mark the column as required. They also set a reference to the respective model to
            // create a foreign key constraint. As in Chapter 9, “Parent-Child Relationships,” it’s good practice to use foreign key constraints with sibling relationships.
            // The current WordCategoryPivot does not check the IDs for the words and categories.
            // Without the constraint you can delete words and categories that are still linked by the pivot and
            // the relationship will remain, without flagging an error. The migration also sets a cascade schema reference action
            // when you delete the model. This causes the database to remove the relationship automatically instead of throwing an error.
            .field("wordID", .uuid, .required, .references("words", "id", onDelete: .cascade))
            .field("categoryID", .uuid, .required, .references("categories", "id", onDelete: .cascade))
            // Call create() to create the table in the database.
            .create()
    }
    
    // Implement revert(on:) as required by Migration. This deletes the table in the database.
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("word-category-pivot").delete()
    }
}

