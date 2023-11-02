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
        wordsRoutes.post(use: createHandler)
        wordsRoutes.get(":wordID", use: getHandler)
        wordsRoutes.put(":wordID", use: updateHandler)
        wordsRoutes.delete(":wordID", use: deleteHandler)
        wordsRoutes.get("search", use: searchHandler)
        wordsRoutes.get("first", use: getFirstHandler)
        wordsRoutes.get("sorted", use: sortedHandler)
        wordsRoutes.get(":wordID", "user", use: getUserHandler)

    }
    
    func getAllHandler(_ req: Request) async throws -> [Word] {
        try await Word.query(on: req.db).all()
    }
    
    func createHandler(_ req: Request) async throws -> Word {
        // Decode the request body to CreateWordData instead of Word
        let data = try req.content.decode(CreateWordData.self)
        // Create an Word from the data received.
        let acronym = Word(
            name: data.name,
            meaning: data.meaning,
            userID: data.userID)
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
            let updatedWord = try req.content.decode(CreateWordData.self)//req.content.decode(Word.self)
            guard let result = try await Word.find(req.parameters.get("wordID"), on: req.db) else {
                throw Abort(.notFound)
            }
            
            result.name = updatedWord.name
            result.meaning = updatedWord.meaning
            result.$user.id = updatedWord.userID
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
    
    func getUserHandler(_ req: Request) async throws -> User {
        do {
            guard let word = try await Word.find(req.parameters.get("wordID"), on: req.db) else {
                throw Abort(.notFound)
            }
            
            return try await word.$user.get(on: req.db)
        } catch {
            throw Abort(.badRequest, reason: "Invalid wordID parameter")
        }
    }
}

struct CreateWordData: Content {
    let name: String
    let meaning: String
    let userID: UUID
}
