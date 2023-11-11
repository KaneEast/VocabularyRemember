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
        
        
        
        usersRoute.get(use: getAllHandler)
        usersRoute.post(use: createHandler)
        usersRoute.get(":userID", use: getHandler)
        usersRoute.get(":userID", "words", use: getWordsHandler)
        
        /// Create a protected route group using HTTP basic authentication, as you did for creating an word.
        /// This doesn’t use GuardAuthenticationMiddleware since req.auth.require(_:) throws the correct error if a user isn’t authenticated.
        let basicAuthMiddleware = User.authenticator()
        let basicAuthGroup = usersRoute.grouped(basicAuthMiddleware)
        // Connect /api/users/login to loginHandler(_:) through the protected group.
        basicAuthGroup.post("login", use: loginHandler)

        /// using tokenAuthMiddleware and guardAuthMiddleware ensures only authenticated users can create other users.
        /// This prevents anyone from creating a user to send requests to the routes you’ve just protected!
        let tokenAuthMiddleware = Token.authenticator()
        let guardAuthMiddleware = User.guardMiddleware()
        let tokenAuthGroup = usersRoute.grouped(
          tokenAuthMiddleware,
          guardAuthMiddleware)
//        tokenAuthGroup.post(use: createHandler)

    }
    
    // Define the route handler function.
    func createHandler(_ req: Request) async throws -> User.Public {
        // TODO: check if exsist
        
        // Decode the user from the request body.
        let user = try req.content.decode(User.self)
        user.password = try Bcrypt.hash(user.password)
        // Save the decoded user. save(on:) returns EventLoopFuture<Void> so use map(_:) to wait for the save to complete and return the saved user.
        try await user.save(on: req.db)
        return user.convertToPublic()
    }
    
    func getAllHandler(_ req: Request) async throws -> [User.Public] {
        let users = try await User.query(on: req.db).all()
        return users.convertToPublic()
    }
    
    func getHandler(_ req: Request) -> EventLoopFuture<User.Public> {
        User.find(req.parameters.get("userID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .convertToPublic()
    }
    
    func getWordsHandler(_ req: Request) async throws-> [Word] {
        guard let user = try await User.find(req.parameters.get("userID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return try await user.$words.get(on: req.db)
    }
    
    // Define a route handler for logging a user in.
    func loginHandler(_ req: Request) throws -> EventLoopFuture<Token> {
        /// Get the authenticated user from the request. You’ll protect this route with the HTTP basic authentication middleware.
        /// This saves the user’s identity in the request’s authentication cache, allowing you to retrieve the user object later.
        /// req.auth.require(_:) throws an authentication error if there’s no authenticated user.
        let user = try req.auth.require(User.self)
        // Create a token for the user.
        let token = try Token.generate(for: user)
        // Save and return the token.
        return token.save(on: req.db).map { token }
    }
    
}
