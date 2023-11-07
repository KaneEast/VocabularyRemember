//
//  User.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/03.
//

import Foundation

final class User: Codable {
    var id: UUID?
    var name: String
    var username: String
    
    init(name: String, username: String) {
        self.name = name
        self.username = username
    }
}
