//
//  File.swift
//
//
//  Created by Kane on 2023/11/02.
//

@testable import App
import Fluent
import Vapor


extension User {
    // Make the username parameter an optional string that defaults to nil.
    static func create(
        name: String = "Luke",
        username: String? = nil,
        on database: Database
    ) throws -> User {
        let createUsername: String
        // If a username is supplied, use it.
        if let suppliedUsername = username {
            createUsername = suppliedUsername
            /// If a username isn’t supplied, create a new, random one using UUID. This ensures the username is unique as required by the migration.
        } else {
            createUsername = UUID().uuidString
        }
        
        // Hash the password and create a user.
        let password = try Bcrypt.hash("password")
        let user = User(
            name: name,
            username: createUsername,
            password: password)
        try user.save(on: database).wait()
        return user
    }
    
}

extension Word {
    static func create(
        name: String = "TIL",
        meaning: String = "Today I Learned",
        user: User? = nil,
        on database: Database
    ) throws -> Word {
        var acronymsUser = user
        
        if acronymsUser == nil {
            acronymsUser = try User.create(on: database)
        }
        
        let acronym = Word(
            name: name,
            meaning: meaning,
            userID: acronymsUser!.id!)
        try acronym.save(on: database).wait()
        return acronym
    }
}

extension App.Category {
    static func create(
        name: String = "Random",
        on database: Database
    ) throws -> App.Category {
        let category = Category(name: name)
        try category.save(on: database).wait()
        return category
    }
}

