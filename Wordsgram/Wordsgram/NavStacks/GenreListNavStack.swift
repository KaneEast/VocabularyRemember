//
//  GenreListNavStack.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/26.
//

import Foundation
enum GenreListNavStack: String, CaseIterable {
    case iJustine = "iJustine"
    case kaviya = "Kaviya"
    case jenna = "Jenna"
    
    static func convert(from: String) -> Self? {
        return self.allCases.first { tab in
            tab.rawValue.lowercased() == from.lowercased()
        }
    }
}
