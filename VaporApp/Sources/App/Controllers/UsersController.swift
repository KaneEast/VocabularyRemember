//
//  File.swift
//
//
//  Created by Kane on 2023/11/02.
//

import Vapor

// Define a new type UsersController that conforms to RouteCollection.
struct UsersController: RouteCollection {
    // Implement boot(routes:) as required by RouteCollection.
    func boot(routes: RoutesBuilder) throws {
        // Create a new route group for the path /api/users.
        let usersRoute = routes.grouped("api", "users")
        usersRoute.post(use: createHandler)
        usersRoute.get(use: getAllHandler)
        usersRoute.get(":userID", use: getHandler)
        usersRoute.get(":userID", "words", use: getWordsHandler)

    }
    
    // Define the route handler function.
    func createHandler(_ req: Request) async throws -> User {
        // Decode the user from the request body.
        let user = try req.content.decode(User.self)
        // Save the decoded user. save(on:) returns EventLoopFuture<Void> so use map(_:) to wait for the save to complete and return the saved user.
        try await user.save(on: req.db)
        return user
    }
    
    func getAllHandler(_ req: Request) async throws -> [User] {
        try await User.query(on: req.db).all()
    }
    
    func getHandler(_ req: Request) -> EventLoopFuture<User> {
        User.find(req.parameters.get("userID"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    func getWordsHandler(_ req: Request) async throws-> [Word] {
        guard let user = try await User.find(req.parameters.get("userID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return try await user.$words.get(on: req.db)
    }
}
