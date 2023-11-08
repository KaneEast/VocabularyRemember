//
//  CreateWordResponse.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/09.
//

import Foundation
struct CreateWordResponse: Codable {
    let name, id, meaning: String
    let user: User
    
    // MARK: - User
    struct User: Codable {
        let id: String
    }
}


