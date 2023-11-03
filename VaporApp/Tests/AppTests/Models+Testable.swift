//
//  File.swift
//
//
//  Created by Kane on 2023/11/02.
//

@testable import App
import Fluent

extension User {
    static func create(
        name: String = "Luke",
        username: String = "lukes",
        on database: Database
    ) throws -> User {
        let user = User(name: name, username: username, password: "password")
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

