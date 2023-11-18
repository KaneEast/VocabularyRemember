//
//  CategoryResponse.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/09.
//

import Foundation
struct CategoryWithWordResponse: Codable {
    let category: CategoryResponse
    let words: [WordResponse]
}

// MARK: - Category
struct CategoryResponse: Codable {
    let name, id: String
}

// MARK: - Word
struct WordResponse: Codable {
    let meaning, name, id: String
    let user: UserResponse
}

// MARK: - User
struct UserResponse: Codable {
    let id: String
}
