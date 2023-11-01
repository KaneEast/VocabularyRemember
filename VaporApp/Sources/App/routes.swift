import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }
    
    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    // old code
    //    app.post("api", "words") { req -> EventLoopFuture<Word> in
    //        let word = try req.content.decode(Word.self)
    //        return word.save(on: req.db).map {
    //            word
    //        }
    //    }
    
    // new code
    // CREATE
    app.post("api", "words") { req async throws -> Word in
        let word = try req.content.decode(Word.self)
        try await word.save(on: req.db)
        return word
    }
    
    // GET ALL
    // GET http://localhost:8080/api/words HTTP/1.1
    // content-length: 21
    // content-type: application/json
    app.get("api", "words") { req async throws -> [Word] in
        try await Word.query(on: req.db).all()
    }
    
    // 1
    app.get("api", "acronyms", "first") { req async throws -> Word in
        do {
            return try await Word.query(on: req.db).first()!
        } catch {
            throw Abort(.notFound)
        }
    }

    
    // GET - SEARCH
    // GET http://localhost:8080/api/words/191045C9-824C-445C-A3B0-5B3CABA277CB HTTP/1.1
    // content-length: 21
    // content-type: application/json
    app.get("api", "words", ":wordID") { req async throws -> Word in
        do {
            return try await Word.find(req.parameters.get("wordID"), on: req.db)!
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
    app.put("api", "words", ":wordID") { req async throws -> Word in
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
    app.delete("api", "words", ":wordID") { req async throws -> HTTPStatus in
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
    app.get("api", "words", "search") { req async throws -> [Word] in
        guard let searchTerm = req.query[String.self, at: "term"] else {
            throw Abort(.badRequest)
        }
        
        let result = try await Word.query(on: req.db).group(.or) { group in
            group.filter(\.$name == searchTerm).filter(\.$meaning == searchTerm)
        }.all()
        return result
    }
    
}
