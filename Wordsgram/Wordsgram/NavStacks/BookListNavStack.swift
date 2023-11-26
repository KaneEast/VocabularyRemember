//
//  BookListNavStack.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/26.
//

import Foundation
enum BookListNavStack: String, CaseIterable {
    case myPosts = "My Posts"
    case oldPosts = "Old Posts"
    case latestPosts = "Latest Posts"
    case deletedPosts = "Deleted Posts"
    
    static func convert(from: String) -> Self? {
        return self.allCases.first { tab in
            tab.rawValue.lowercased() == from.lowercased()
        }
    }
}
