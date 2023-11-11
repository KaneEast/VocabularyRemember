//
//  File.swift
//
//
//  Created by Kane on 2023/11/02.
//

@testable import App
import XCTVapor

final class CategoryTests: XCTestCase {
    let categoriesURI = "/api/categories/"
    let categoryName = "Teenager"
    var app: Application!
    
    override func setUp() {
        let expectation = self.expectation(description: "Setup")
        
        // Use async tasks
        Task {
            do {
                app = try await Application.testable()
                expectation.fulfill()
            } catch {
                XCTFail("Error setting up: \(error)")
            }
        }
        
        waitForExpectations(timeout: 3) { error in
            if let error = error {
                XCTFail("Error setting up with timeout: \(error)")
            }
        }
    }
    
    override func tearDown() {
        app.shutdown()
    }
    
    func testCategoriesCanBeRetrievedFromAPI() throws {
        let category = try Category.create(name: categoryName, on: app.db)
        _ = try Category.create(on: app.db)
        
        try app.test(.GET, categoriesURI, afterResponse: { response in
            let categories = try response.content.decode([App.Category].self)
            XCTAssertEqual(categories.count, 2)
            XCTAssertEqual(categories[0].name, categoryName)
            XCTAssertEqual(categories[0].id, category.id)
        })
    }
    
    func testCategoryCanBeSavedWithAPI() throws {
        let category = Category(name: categoryName)
        
        try app.test(.POST, categoriesURI, loggedInRequest: true, beforeRequest: { request in
            try request.content.encode(category)
        }, afterResponse: { response in
            let receivedCategory = try response.content.decode(Category.self)
            XCTAssertEqual(receivedCategory.name, categoryName)
            XCTAssertNotNil(receivedCategory.id)
            
            try app.test(.GET, categoriesURI, afterResponse: { response in
                let categories = try response.content.decode([App.Category].self)
                XCTAssertEqual(categories.count, 1)
                XCTAssertEqual(categories[0].name, categoryName)
                XCTAssertEqual(categories[0].id, receivedCategory.id)
            })
        })
    }
    
    func testGettingASingleCategoryFromTheAPI() throws {
        let category = try Category.create(name: categoryName, on: app.db)
        
        try app.test(.GET, "\(categoriesURI)\(category.id!)", afterResponse: { response in
            let returnedCategory = try response.content.decode(Category.self)
            XCTAssertEqual(returnedCategory.name, categoryName)
            XCTAssertEqual(returnedCategory.id, category.id)
        })
    }
    
    func testGettingACategoriesAcronymsFromTheAPI() throws {
        let wordShort = "OMG"
        let wordLong = "Oh My God"
        let word = try Word.create(name: wordShort, meaning: wordLong, on: app.db)
        let word2 = try Word.create(on: app.db)
        
        let category = try Category.create(name: categoryName, on: app.db)
        
        try app.test(.POST, "/api/words/\(word.id!)/categories/\(category.id!)", loggedInRequest: true)
        try app.test(.POST, "/api/words/\(word2.id!)/categories/\(category.id!)", loggedInRequest: true)
        
        try app.test(.GET, "\(categoriesURI)\(category.id!)/words", afterResponse: { response in
            let words = try response.content.decode([Word].self)
            XCTAssertEqual(words.count, 2)
            XCTAssertEqual(words[0].id, word.id)
            XCTAssertEqual(words[0].name, wordShort)
            XCTAssertEqual(words[0].meaning, wordLong)
        })
        
    }
}
