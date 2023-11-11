//
//  File.swift
//  
//
//  Created by Kane on 2023/11/02.
//

@testable import App
import XCTVapor

final class WordTests: XCTestCase {
    let wordsURI = "/api/words/"
    let wordname = "OMG"
    let wordLong = "Oh My God"
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
        let word1 = try Word.create(name: wordname, meaning: wordLong, on: app.db)
        _ = try Word.create(on: app.db)
        
        try app.test(.GET, wordsURI, afterResponse: { response in
            let words = try response.content.decode([Word].self)
            XCTAssertEqual(words.count, 2)
            XCTAssertEqual(words[0].name, wordname)
            XCTAssertEqual(words[0].meaning, wordLong)
            XCTAssertEqual(words[0].id, word1.id)
        })
    }
    
    func testWordCanBeSavedWithAPI() throws {
        let user = try User.create(on: app.db)

//        let user = try User.create(on: app.db)
//        let createWordData = CreateWordData(name: wordname, meaning: wordLong, userID: user.id!)
        let createWordData = CreateWordData(name: wordname, meaning: wordLong)

        
        try app.test(.POST, wordsURI, loggedInUser: user,beforeRequest: { request in
            try request.content.encode(createWordData)
        }, afterResponse: { response in
            let receivedWord = try response.content.decode(Word.self)
            XCTAssertEqual(receivedWord.name, wordname)
            XCTAssertEqual(receivedWord.meaning, wordLong)
            XCTAssertNotNil(receivedWord.id)
            XCTAssertEqual(receivedWord.$user.id, user.id)
            
            try app.test(.GET, wordsURI, afterResponse: { allWordsResponse in
                let words = try allWordsResponse.content.decode([Word].self)
                XCTAssertEqual(words.count, 1)
                XCTAssertEqual(words[0].name, wordname)
                XCTAssertEqual(words[0].meaning, wordLong)
                XCTAssertEqual(words[0].id, receivedWord.id)
                XCTAssertEqual(words[0].$user.id, user.id)
            })
        })
    }
    
    func testGettingASingleWordFromTheAPI() throws {
        let word = try Word.create(name: wordname, meaning: wordLong, on: app.db)
        
        try app.test(.GET, "\(wordsURI)\(word.id!)", afterResponse: { response in
            let returnedWord = try response.content.decode(Word.self)
            XCTAssertEqual(returnedWord.name, wordname)
            XCTAssertEqual(returnedWord.meaning, wordLong)
            XCTAssertEqual(returnedWord.id, word.id)
        })
    }
    
    func testUpdatingAnWord() throws {
        let word = try Word.create(name: wordname, meaning: wordLong, on: app.db)
        let newUser = try User.create(on: app.db)
        let newLong = "Oh My Gosh"
        let updatedWordData = CreateWordData(name: wordname, meaning: newLong)//, userID: newUser.id!)
        
        try app.test(.PUT, "\(wordsURI)\(word.id!)", loggedInUser: newUser,beforeRequest: { request in
            try request.content.encode(updatedWordData)
        })
        
        try app.test(.GET, "\(wordsURI)\(word.id!)", afterResponse: { response in
            let returnedWord = try response.content.decode(Word.self)
            XCTAssertEqual(returnedWord.name, wordname)
            XCTAssertEqual(returnedWord.meaning, newLong)
            XCTAssertEqual(returnedWord.$user.id, newUser.id)
        })
    }
    
    func testDeletingAnWord() throws {
        let word = try Word.create(on: app.db)
        
        try app.test(.GET, wordsURI, afterResponse: { response in
            let words = try response.content.decode([Word].self)
            XCTAssertEqual(words.count, 1)
        })
        
        try app.test(.DELETE, "\(wordsURI)\(word.id!)", loggedInRequest: true)
        
        try app.test(.GET, wordsURI, afterResponse: { response in
            let newWords = try response.content.decode([Word].self)
            XCTAssertEqual(newWords.count, 0)
        })
    }
    
    func testSearchWordname() throws {
        let word = try Word.create(name: wordname, meaning: wordLong, on: app.db)
        
        try app.test(.GET, "\(wordsURI)search?term=OMG", afterResponse: { response in
            let words = try response.content.decode([Word].self)
            XCTAssertEqual(words.count, 1)
            XCTAssertEqual(words[0].id, word.id)
            XCTAssertEqual(words[0].name, wordname)
            XCTAssertEqual(words[0].meaning, wordLong)
        })
    }
    
    func testSearchWordLong() throws {
        let word = try Word.create(name: wordname, meaning: wordLong, on: app.db)
        
        try app.test(.GET, "\(wordsURI)search?term=Oh+My+God", afterResponse: { response in
            let words = try response.content.decode([Word].self)
            XCTAssertEqual(words.count, 1)
            XCTAssertEqual(words[0].id, word.id)
            XCTAssertEqual(words[0].name, wordname)
            XCTAssertEqual(words[0].meaning, wordLong)
        })
    }
    
    func testGetFirstWord() throws {
        let word = try Word.create(name: wordname, meaning: wordLong, on: app.db)
        _ = try Word.create(on: app.db)
        _ = try Word.create(on: app.db)
        
        try app.test(.GET, "\(wordsURI)first", afterResponse: { response in
            let firstWord = try response.content.decode(Word.self)
            XCTAssertEqual(firstWord.id, word.id)
            XCTAssertEqual(firstWord.name, wordname)
            XCTAssertEqual(firstWord.meaning, wordLong)
        })
    }
    
    func testSortingWords() throws {
        let name2 = "LOL"
        let meaming2 = "Laugh Out Loud"
        let word1 = try Word.create(name: wordname, meaning: wordLong, on: app.db)
        let word2 = try Word.create(name: name2, meaning: meaming2, on: app.db)
        
        try app.test(.GET, "\(wordsURI)sorted", afterResponse: { response in
            let sortedWords = try response.content.decode([Word].self)
            XCTAssertEqual(sortedWords[0].id, word2.id)
            XCTAssertEqual(sortedWords[1].id, word1.id)
        })
    }
    
    func testGettingAnWordsUser() throws {
        let user = try User.create(on: app.db)
        let word = try Word.create(user: user, on: app.db)
        
        try app.test(.GET, "\(wordsURI)\(word.id!)/user", afterResponse: { response in
//            let wordsUser = try response.content.decode(User.self)
            let wordsUser = try response.content.decode(User.Public.self)
            XCTAssertEqual(wordsUser.id, user.id)
            XCTAssertEqual(wordsUser.name, user.name)
            XCTAssertEqual(wordsUser.username, user.username)
        })
    }
    
    func testWordsCategories() throws {
        let category = try Category.create(on: app.db)
        let category2 = try Category.create(name: "Funny", on: app.db)
        let word = try Word.create(on: app.db)
        
        try app.test(.POST, "\(wordsURI)\(word.id!)/categories/\(category.id!)", loggedInRequest: true)
        try app.test(.POST, "\(wordsURI)\(word.id!)/categories/\(category2.id!)", loggedInRequest: true)
        
        try app.test(.GET, "\(wordsURI)\(word.id!)/categories", afterResponse: { response in
            let categories = try response.content.decode([App.Category].self)
            XCTAssertEqual(categories.count, 2)
            XCTAssertEqual(categories[0].id, category.id)
            XCTAssertEqual(categories[0].name, category.name)
            XCTAssertEqual(categories[1].id, category2.id)
            XCTAssertEqual(categories[1].name, category2.name)
        })
        
        try app.test(.DELETE, "\(wordsURI)\(word.id!)/categories/\(category.id!)", loggedInRequest: true)
        
        try app.test(.GET, "\(wordsURI)\(word.id!)/categories", afterResponse: { response in
            let newCategories = try response.content.decode([App.Category].self)
            XCTAssertEqual(newCategories.count, 1)
        })
    }
}

