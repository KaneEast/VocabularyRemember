//
//  Category.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/03.
//

import Foundation

final class Category: Codable {
    var id: UUID?
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
