//
//  Token.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/03.
//

import Foundation

final class Token: Codable {
    var id: UUID?
    var value: String
    
    init(value: String) {
        self.value = value
    }
}
