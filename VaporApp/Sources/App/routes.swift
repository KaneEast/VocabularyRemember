import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }
    
    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    let wordsController = WordsController()
    try app.register(collection: wordsController)
    
    let usersController = UsersController()
    try app.register(collection: usersController)

    let categoriesController = CategoriesController()
    try app.register(collection: categoriesController)
}
