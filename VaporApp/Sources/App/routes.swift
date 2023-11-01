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

    // GET - SEARCH
    // GET http://localhost:8080/api/words/191045C9-824C-445C-A3B0-5B3CABA277CB HTTP/1.1
    // content-length: 21
    // content-type: application/json
    app.get("api", "words", ":wordID") { req async throws -> Word in
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

}
