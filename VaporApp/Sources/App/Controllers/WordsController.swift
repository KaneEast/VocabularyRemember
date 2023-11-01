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
    }
    
    // GET ALL
    // GET http://localhost:8080/api/words HTTP/1.1
    // content-length: 21
    // content-type: application/json
    func getAllHandler(_ req: Request) async throws -> [Word] {
        try await Word.query(on: req.db).all()
    }
    
    //    POST http://localhost:8080/api/words HTTP/1.1
    //    content-length: 21
    //    content-type: application/json
    //
    //    {
    //        "name": "Milky Way",
    //        "meaning": "absdad"
    //    }
    func createHandler(_ req: Request) async throws -> Word {
        let word = try req.content.decode(Word.self)
        try await word.save(on: req.db)
        return word
    }
    
    // GET - SEARCH
    // GET http://localhost:8080/api/words/191045C9-824C-445C-A3B0-5B3CABA277CB HTTP/1.1
    // content-length: 21
    // content-type: application/json
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
    
    // PUT - UPDATE
    //    PUT http://localhost:8080/api/words/191045C9-824C-445C-A3B0-5B3CABA277CB HTTP/1.1
    //    content-length: 21
    //    content-type: application/json
    //
    //    {
    //        "name": "Milky Way",
    //        "meaning": "absdad31313131"
    //    }
    func updateHandler(_ req: Request) async throws -> Word {
        let updatedWord = try req.content.decode(Word.self)
        do {
            let result = try await Word.find(req.parameters.get("wordID"), on: req.db)
            guard let result else {
                throw Abort(.notFound)
            }
            
            result.name = updatedWord.name
            result.meaning = updatedWord.meaning
            try await result.save(on: req.db)
            return result
        } catch {
            throw Abort(.notFound)
        }
    }
    
    // DELETE
    //    DELETE http://localhost:8080/api/words/191045C9-824C-445C-A3B0-5B3CABA277CB HTTP/1.1
    //    content-length: 21
    //    content-type: application/json
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
    
    // queries
    //    GET http://localhost:8080/api/words/search?term=Milky%20Way
    //    content-length: 21
    //    content-type: application/json
    func searchHandler(_ req: Request) async throws -> [Word] {
        guard let searchTerm = req.query[String.self, at: "term"] else {
            throw Abort(.badRequest)
        }
        
        let result = try await Word.query(on: req.db).group(.or) { group in
            group.filter(\.$name == searchTerm).filter(\.$meaning == searchTerm)
        }.all()
        return result
    }
    
    // FIRST
    //    GET http://localhost:8080/api/words/first
    //    content-length: 21
    //    content-type: application/json
    func getFirstHandler(_ req: Request) async throws -> Word {
        do {
            let result = try await Word.query(on: req.db).first()
            guard let result else {
                throw Abort(.notFound)
            }
            return result
        } catch {
            throw Abort(.notFound)
        }
    }
    
    // SORT
    //    GET http://localhost:8080/api/words/sorted
    //    content-length: 21
    //    content-type: application/json
    func sortedHandler(_ req: Request) async throws -> [Word] {
        try await Word.query(on: req.db).sort(\.$name, .ascending).all()
    }
}
