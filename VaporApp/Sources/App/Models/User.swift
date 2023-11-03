//
//  User.swift
//
//
//  Created by Kane on 2023/11/02.
//

import Fluent
import Vapor

final class User: Model, Content {
    static let schema = "users"
    
    @ID
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "username")
    var username: String
    
    @Field(key: "password")
    var password: String
    
    @Children(for: \.$user)
    var words: [Word]
    
    init() {}
    
    init(id: UUID? = nil, name: String, username: String, password: String) {
        self.name = name
        self.username = username
        self.password = password
    }
    
    final class Public: Content {
        var id: UUID?
        var name: String
        var username: String
        
        init(id: UUID?, name: String, username: String) {
            self.id = id
            self.name = name
            self.username = username
        }
    }
}

extension User {
    // Define a method on User that returns User.Public.
    func convertToPublic() -> User.Public {
        // Create a public version of the current object.
        return User.Public(id: id, name: name, username: username)
    }
}

// Define an extension for EventLoopFuture<User>.
extension EventLoopFuture where Value: User {
    // Define a new method that returns a EventLoopFuture<User.Public>.
    func convertToPublic() -> EventLoopFuture<User.Public> {
        // Unwrap the user contained in self.
        return self.map { user in
            // Convert the User object to User.Public.
            return user.convertToPublic()
        }
    }
}

// Define an extension for [User].
extension Collection where Element: User {
    // Define a new method that returns [User.Public].
    func convertToPublic() -> [User.Public] {
        // Convert all the User objects in the array to User.Public.
        return self.map { $0.convertToPublic() }
    }
}

// Define an extension for EventLoopFuture<[User]>.
extension EventLoopFuture where Value == Array<User> {
    // Define a new method that returns EventLoopFuture<[User.Public]>.
    func convertToPublic() -> EventLoopFuture<[User.Public]> {
        // Unwrap the array contained in the future and use the previous extension to convert all the Users to User.Public.
        return self.map { $0.convertToPublic() }
    }
}

// Conform User to ModelAuthenticatable. This is a protocol that allows Fluent Models to use HTTP Basic Authentication.
extension User: ModelAuthenticatable {
    // Tell Vapor which key path of User is the username.
    static let usernameKey = \User.$username
    // Tell Vapor which key path of User is the password hash.
    static let passwordHashKey = \User.$password
    
    // Implement verify(password:) as required by ModelAuthenticatable.
    // Since you hash the User’s password using Bcrypt, verify the hash with Bcrypt here.
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
}
