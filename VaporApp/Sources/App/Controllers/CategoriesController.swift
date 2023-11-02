//
//  CategoriesController.swift
//
//
//  Created by Kane on 2023/11/02.
//

import Vapor

struct CategoriesController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let categoriesRoute = routes.grouped("api", "categories")
        categoriesRoute.post(use: createHandler)
        categoriesRoute.get(use: getAllHandler)
        categoriesRoute.get(":categoryID", use: getHandler)
        categoriesRoute.get(
          ":categoryID",
          "words",
          use: getAcronymsHandler)

    }
    
    func createHandler(_ req: Request) throws -> EventLoopFuture<Category> {
        let category = try req.content.decode(Category.self)
        return category.save(on: req.db).map { category }
    }
    
    func getAllHandler(_ req: Request) -> EventLoopFuture<[Category]> {
        Category.query(on: req.db).all()
    }
    
    func getHandler(_ req: Request) -> EventLoopFuture<Category> {
        Category.find(req.parameters.get("categoryID"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    // Define a new route handler, getAcronymsHandler(_:), that returns EventLoopFuture<[Acronym]>.
    func getAcronymsHandler(_ req: Request) -> EventLoopFuture<[Word]> {
        //Get the category from the database using the ID provided to the request. Ensure one is returned and unwrap the future.
        Category.find(req.parameters.get("categoryID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { category in
                // Use the new property wrapper to get the acronyms. This uses get(on:) to perform the query for you. This is the same as query(on: req.db).all() from earlier.
                category.$words.get(on: req.db)
            }
    }
    
}

