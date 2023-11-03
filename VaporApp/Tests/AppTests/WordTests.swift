//
//  File.swift
//  
//
//  Created by Kane on 2023/11/02.
//

@testable import App
import XCTVapor

final class WordTests: XCTestCase {
    let acronymsURI = "/api/words/"
    let acronymname = "OMG"
    let acronymLong = "Oh My God"
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
    
    func testWordsCanBeRetrievedFromAPI() throws {
        let acronym1 = try Word.create(name: acronymname, meaning: acronymLong, on: app.db)
        _ = try Word.create(on: app.db)
        
        try app.test(.GET, acronymsURI, afterResponse: { response in
            let acronyms = try response.content.decode([Word].self)
            XCTAssertEqual(acronyms.count, 2)
            XCTAssertEqual(acronyms[0].name, acronymname)
            XCTAssertEqual(acronyms[0].meaning, acronymLong)
            XCTAssertEqual(acronyms[0].id, acronym1.id)
        })
    }
    
    func testWordCanBeSavedWithAPI() throws {
        let user = try User.create(on: app.db)

//        let user = try User.create(on: app.db)
//        let createWordData = CreateWordData(name: acronymname, meaning: acronymLong, userID: user.id!)
        let createWordData = CreateWordData(name: acronymname, meaning: acronymLong)

        
        try app.test(.POST, acronymsURI, loggedInUser: user,beforeRequest: { request in
            try request.content.encode(createWordData)
        }, afterResponse: { response in
            let receivedWord = try response.content.decode(Word.self)
            XCTAssertEqual(receivedWord.name, acronymname)
            XCTAssertEqual(receivedWord.meaning, acronymLong)
            XCTAssertNotNil(receivedWord.id)
            XCTAssertEqual(receivedWord.$user.id, user.id)
            
            try app.test(.GET, acronymsURI, afterResponse: { allWordsResponse in
                let acronyms = try allWordsResponse.content.decode([Word].self)
                XCTAssertEqual(acronyms.count, 1)
                XCTAssertEqual(acronyms[0].name, acronymname)
                XCTAssertEqual(acronyms[0].meaning, acronymLong)
                XCTAssertEqual(acronyms[0].id, receivedWord.id)
                XCTAssertEqual(acronyms[0].$user.id, user.id)
            })
        })
    }
    
    func testGettingASingleWordFromTheAPI() throws {
        let acronym = try Word.create(name: acronymname, meaning: acronymLong, on: app.db)
        
        try app.test(.GET, "\(acronymsURI)\(acronym.id!)", afterResponse: { response in
            let returnedWord = try response.content.decode(Word.self)
            XCTAssertEqual(returnedWord.name, acronymname)
            XCTAssertEqual(returnedWord.meaning, acronymLong)
            XCTAssertEqual(returnedWord.id, acronym.id)
        })
    }
    
    func testUpdatingAnWord() throws {
        let acronym = try Word.create(name: acronymname, meaning: acronymLong, on: app.db)
        let newUser = try User.create(on: app.db)
        let newLong = "Oh My Gosh"
        let updatedWordData = CreateWordData(name: acronymname, meaning: newLong)//, userID: newUser.id!)
        
        try app.test(.PUT, "\(acronymsURI)\(acronym.id!)", loggedInUser: newUser,beforeRequest: { request in
            try request.content.encode(updatedWordData)
        })
        
        try app.test(.GET, "\(acronymsURI)\(acronym.id!)", afterResponse: { response in
            let returnedWord = try response.content.decode(Word.self)
            XCTAssertEqual(returnedWord.name, acronymname)
            XCTAssertEqual(returnedWord.meaning, newLong)
            XCTAssertEqual(returnedWord.$user.id, newUser.id)
        })
    }
    
    func testDeletingAnWord() throws {
        let acronym = try Word.create(on: app.db)
        
        try app.test(.GET, acronymsURI, afterResponse: { response in
            let acronyms = try response.content.decode([Word].self)
            XCTAssertEqual(acronyms.count, 1)
        })
        
        try app.test(.DELETE, "\(acronymsURI)\(acronym.id!)", loggedInRequest: true)
        
        try app.test(.GET, acronymsURI, afterResponse: { response in
            let newWords = try response.content.decode([Word].self)
            XCTAssertEqual(newWords.count, 0)
        })
    }
    
    func testSearchWordname() throws {
        let acronym = try Word.create(name: acronymname, meaning: acronymLong, on: app.db)
        
        try app.test(.GET, "\(acronymsURI)search?term=OMG", afterResponse: { response in
            let acronyms = try response.content.decode([Word].self)
            XCTAssertEqual(acronyms.count, 1)
            XCTAssertEqual(acronyms[0].id, acronym.id)
            XCTAssertEqual(acronyms[0].name, acronymname)
            XCTAssertEqual(acronyms[0].meaning, acronymLong)
        })
    }
    
    func testSearchWordLong() throws {
        let acronym = try Word.create(name: acronymname, meaning: acronymLong, on: app.db)
        
        try app.test(.GET, "\(acronymsURI)search?term=Oh+My+God", afterResponse: { response in
            let acronyms = try response.content.decode([Word].self)
            XCTAssertEqual(acronyms.count, 1)
            XCTAssertEqual(acronyms[0].id, acronym.id)
            XCTAssertEqual(acronyms[0].name, acronymname)
            XCTAssertEqual(acronyms[0].meaning, acronymLong)
        })
    }
    
    func testGetFirstWord() throws {
        let acronym = try Word.create(name: acronymname, meaning: acronymLong, on: app.db)
        _ = try Word.create(on: app.db)
        _ = try Word.create(on: app.db)
        
        try app.test(.GET, "\(acronymsURI)first", afterResponse: { response in
            let firstWord = try response.content.decode(Word.self)
            XCTAssertEqual(firstWord.id, acronym.id)
            XCTAssertEqual(firstWord.name, acronymname)
            XCTAssertEqual(firstWord.meaning, acronymLong)
        })
    }
    
    func testSortingWords() throws {
        let name2 = "LOL"
        let meaming2 = "Laugh Out Loud"
        let acronym1 = try Word.create(name: acronymname, meaning: acronymLong, on: app.db)
        let acronym2 = try Word.create(name: name2, meaning: meaming2, on: app.db)
        
        try app.test(.GET, "\(acronymsURI)sorted", afterResponse: { response in
            let sortedWords = try response.content.decode([Word].self)
            XCTAssertEqual(sortedWords[0].id, acronym2.id)
            XCTAssertEqual(sortedWords[1].id, acronym1.id)
        })
    }
    
    func testGettingAnWordsUser() throws {
        let user = try User.create(on: app.db)
        let acronym = try Word.create(user: user, on: app.db)
        
        try app.test(.GET, "\(acronymsURI)\(acronym.id!)/user", afterResponse: { response in
//            let acronymsUser = try response.content.decode(User.self)
            let acronymsUser = try response.content.decode(User.Public.self)
            XCTAssertEqual(acronymsUser.id, user.id)
            XCTAssertEqual(acronymsUser.name, user.name)
            XCTAssertEqual(acronymsUser.username, user.username)
        })
    }
    
    func testWordsCategories() throws {
        let category = try Category.create(on: app.db)
        let category2 = try Category.create(name: "Funny", on: app.db)
        let acronym = try Word.create(on: app.db)
        
        try app.test(.POST, "\(acronymsURI)\(acronym.id!)/categories/\(category.id!)", loggedInRequest: true)
        try app.test(.POST, "\(acronymsURI)\(acronym.id!)/categories/\(category2.id!)", loggedInRequest: true)
        
        try app.test(.GET, "\(acronymsURI)\(acronym.id!)/categories", afterResponse: { response in
            let categories = try response.content.decode([App.Category].self)
            XCTAssertEqual(categories.count, 2)
            XCTAssertEqual(categories[0].id, category.id)
            XCTAssertEqual(categories[0].name, category.name)
            XCTAssertEqual(categories[1].id, category2.id)
            XCTAssertEqual(categories[1].name, category2.name)
        })
        
        try app.test(.DELETE, "\(acronymsURI)\(acronym.id!)/categories/\(category.id!)", loggedInRequest: true)
        
        try app.test(.GET, "\(acronymsURI)\(acronym.id!)/categories", afterResponse: { response in
            let newCategories = try response.content.decode([App.Category].self)
            XCTAssertEqual(newCategories.count, 1)
        })
    }
}

