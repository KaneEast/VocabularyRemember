//
//  File.swift
//
//
//  Created by Kane on 2023/11/03.
//

import Vapor
import Fluent

final class Token: Model, Content {
    static let schema = "tokens"
    
    @ID var id: UUID?
    
    // the token string provided to clients.
    @Field(key: "value") var value: String
    
    // user: a @Parent field to the token owner’s user.
    @Parent(key: "userID") var user: User
    
    init() {}
    
    init(id: UUID? = nil, value: String, userID: User.IDValue) {
        self.id = id
        self.value = value
        self.$user.id = userID
    }
}

extension Token {
    // Define a static method to generate a token for a user.
    static func generate(for user: User) throws -> Token {
        // Generate 16 random bytes to act as the token and Base64 encode it.
        let random = [UInt8].random(count: 16).base64
        // Create a Token using the Base64-encoded representation of the random bytes and the user’s ID.
        return try Token(value: random, userID: user.requireID())
    }
}

// Conform Token to Vapor’s ModelTokenAuthenticatable protocol. This allows you to use the token with HTTP Bearer authentication.
extension Token: ModelTokenAuthenticatable {
    // Tell Vapor the key path to the value key, in this case, Token’s value projected value.
    static let valueKey = \Token.$value
    // Tell Vapor the key path to the user key, in this case, Token’s user projected value.
    static let userKey = \Token.$user
    // Tell Vapor what type the user is.
    typealias User = App.User
    /// Determine if the token is valid. Return true for now, but you might add an expiry date or a revoked property to check in the future.
    var isValid: Bool {
        true
    }
}


