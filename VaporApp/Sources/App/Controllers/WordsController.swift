//
//  File.swift
//
//
//  Created by Kane on 2023/11/02.
//

import Vapor
import Fluent

struct WordsController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let wordsRoutes = routes.grouped("api", "words")
        wordsRoutes.get(use: getAllHandler)
        //        wordsRoutes.post(use: createHandler)
        wordsRoutes.get(":wordID", use: getHandler)
        //        wordsRoutes.put(":wordID", use: updateHandler)
        //        wordsRoutes.delete(":wordID", use: deleteHandler)
        wordsRoutes.get("search", use: searchHandler)
        wordsRoutes.get("first", use: getFirstHandler)
        wordsRoutes.get("sorted", use: sortedHandler)
        wordsRoutes.get(":wordID", "user", use: getUserHandler)
        //        wordsRoutes.post(
        //            ":wordID",
        //            "categories",
        //            ":categoryID",
        //            use: addCategoriesHandler)
        
        wordsRoutes.get(
            ":wordID",
            "categories",
            use: getCategoriesHandler)
        
        /// Create a ModelTokenAuthenticator middleware for Token. This extracts the bearer token out of the request and converts it into a logged in user.
        let tokenAuthMiddleware = Token.authenticator()
        let guardAuthMiddleware = User.guardMiddleware()
        /// Create a route group using tokenAuthMiddleware and guardAuthMiddleware to
        /// protect the route for creating an word with token authentication.
        let tokenAuthGroup = wordsRoutes.grouped(
            tokenAuthMiddleware,
            guardAuthMiddleware)
        
        /// Connect the “create word” path to createHandler(_:data:) through this middleware group using the new WordCreateData.
        tokenAuthGroup.post(use: createHandler)
        tokenAuthGroup.delete(":wordID", use: deleteHandler)
        tokenAuthGroup.put(":wordID", use: updateHandler)
        tokenAuthGroup.post(
            ":wordID",
            "categories",
            ":categoryID",
            use: addCategoriesHandler)
        tokenAuthGroup.delete(
            ":wordID",
            "categories",
            ":categoryID",
            use: removeCategoriesHandler)
        
    }
    
    func getAllHandler(_ req: Request) async throws -> [Word] {
        try await Word.query(on: req.db).all()
    }
    
    func createHandler(_ req: Request) async throws -> Word {
        // Decode the request body to CreateWordData instead of Word
        let data = try req.content.decode(CreateWordData.self)
        // Get the authenticated user from the request.
        let user = try req.auth.require(User.self)
        // Create a new Word using the data from the request and the authenticated user.
        let acronym = try Word(
            name: data.name,
            meaning: data.meaning,
            userID: user.requireID())
        
        try await  acronym.save(on: req.db)
        return acronym
    }
    
    func getHandler(_ req: Request) async throws -> Word {
        do {
            let result = try await Word.find(req.parameters.get("wordID"), on: req.db)
            guard let result else {
                throw Abort(.notFound)
            }
            return result
        } catch {
            throw Abort(.notFound)
        }
    }
    
    func updateHandler(_ req: Request) async throws -> Word {
        do {
            let updatedWord = try req.content.decode(CreateWordData.self)
            
            // Get the authenticated user from the request.
            let user = try req.auth.require(User.self)
            /// Get the user ID from the user. It’s useful to do this here as you can’t throw inside flatMap(_:).
            let userID = try user.requireID()
            
            guard let result = try await Word.find(req.parameters.get("wordID"), on: req.db) else {
                throw Abort(.notFound)
            }
            
            result.name = updatedWord.name
            result.meaning = updatedWord.meaning
            result.$user.id = userID
            try await result.save(on: req.db)
            return result
        } catch {
            throw Abort(.notFound)
        }
    }
    
    func deleteHandler(_ req: Request) async throws -> HTTPStatus {
        do {
            guard let toDelete = try await Word.find(req.parameters.get("wordID"), on: req.db) else {
                throw Abort(.notFound)
            }
            
            try await toDelete.delete(on: req.db)
            return .ok
            
        } catch {
            throw Abort(.badRequest, reason: "Invalid wordID parameter")
        }
    }
    
    func searchHandler(_ req: Request) async throws -> [Word] {
        guard let searchTerm = req.query[String.self, at: "term"] else {
            throw Abort(.badRequest)
        }
        
        let result = try await Word.query(on: req.db).group(.or) { group in
            group.filter(\.$name == searchTerm).filter(\.$meaning == searchTerm)
        }.all()
        return result
    }
    
    func getFirstHandler(_ req: Request) async throws -> Word {
        do {
            guard let result = try await Word.query(on: req.db).first() else {
                throw Abort(.notFound)
            }
            return result
        } catch {
            throw Abort(.notFound)
        }
    }
    
    func sortedHandler(_ req: Request) async throws -> [Word] {
        try await Word.query(on: req.db).sort(\.$name, .ascending).all()
    }
    
    func getUserHandler(_ req: Request) async throws -> User.Public {
        do {
            guard let word = try await Word.find(req.parameters.get("wordID"), on: req.db) else {
                throw Abort(.notFound)
            }
            
            return try await word.$user.get(on: req.db).convertToPublic()
        } catch {
            throw Abort(.badRequest, reason: "Invalid wordID parameter")
        }
    }
    
    // Define a new route handler, addCategoriesHandler(_:), that returns EventLoopFuture<HTTPStatus>.
    func addCategoriesHandler(_ req: Request) -> EventLoopFuture<HTTPStatus> {
        // Define two properties to query the database and get the acronym and category from the IDs provided to the request. Each property is an EventLoopFuture.
        let acronymQuery = Word.find(req.parameters.get("wordID"), on: req.db)
            .unwrap(or: Abort(.notFound))
        let categoryQuery = Category.find(req.parameters.get("categoryID"), on: req.db)
            .unwrap(or: Abort(.notFound))
        // Use and(_:) to wait for both futures to return.
        return acronymQuery.and(categoryQuery)
            .flatMap { acronym, category in
                acronym
                    .$categories
                // Use attach(_:on:) to set up the relationship between acronym and category. This creates a pivot model and saves it in the database. Transform the result into a 201 Created response. Like many of Fluent’s operations, you call attach(_:on:) on the property wrappers projected value, rather than the property itself.
                    .attach(category, on: req.db)
                    .transform(to: .created)
            }
    }
    
    // Querying the relationship
    // Defines route handler getCategoriesHandler(_:) returning EventLoopFuture<[Category]>.
    func getCategoriesHandler(_ req: Request) -> EventLoopFuture<[Category]> {
        // Get the word from the database using the provided ID and unwrap the returned future.
        Word.find(req.parameters.get("wordID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { acronym in
                // Use the new property wrapper to get the categories. Then use a Fluent query to return all the categories.
                acronym.$categories.query(on: req.db).all()
            }
    }
    
    // Define a new route handler, removeCategoriesHandler(_:), that returns an EventLoopFuture<HTTPStatus>.
    func removeCategoriesHandler(_ req: Request) -> EventLoopFuture<HTTPStatus> {
        // Perform two queries to get the acronym and category from the IDs provided.
        let acronymQuery = Word.find(req.parameters.get("wordID"), on: req.db)
            .unwrap(or: Abort(.notFound))
        let categoryQuery = Category.find(req.parameters.get("categoryID"), on: req.db)
            .unwrap(or: Abort(.notFound))
        // Use and(_:) to wait for both futures to return.
        return acronymQuery.and(categoryQuery)
            .flatMap { acronym, category in
                // Use detach(_:on:) to remove the relationship between acronym and category. This finds the pivot model in the database and deletes it. Transform the result into a 204 No Content response.
                acronym
                    .$categories
                    .detach(category, on: req.db)
                    .transform(to: .noContent)
            }
    }
    
}

struct CreateWordData: Content {
    let name: String
    let meaning: String
    //    let userID: UUID
}
