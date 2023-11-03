//
//  File.swift
//
//
//  Created by Kane on 2023/11/03.
//

import Fluent
import Vapor

// Define a new type that conforms to Migration.
struct CreateAdminUser: Migration {
    // Implement the required prepare(on:).
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        // Create a password hash from the password. Catch any errors thrown and return a failed future.
        let passwordHash: String
        do {
            /// Note: Obviously, in a production system, you shouldn’t use password as the password for your admin user! You also don’t want to hard code the password in case it ends up in source control. You can either read an environment variable or generate a random password and print it out.
            passwordHash = try Bcrypt.hash("password")
        } catch {
            return database.eventLoop.future(error: error)
        }
        // Create a new user with the name Admin, username admin and the hashed password.
        let user = User(
            name: "Admin",
            username: "admin",
            password: passwordHash)
        // Save the user and return.
        return user.save(on: database)
    }
    
    // Implement the required revert(on:).
    func revert(on database: Database) -> EventLoopFuture<Void> {
        /// Query User and delete any rows where the username matches admin.
        /// As usernames must be unique, this only deletes the one admin row.
        User.query(on: database)
            .filter(\.$username == "admin")
            .delete()
    }
}

