//
//  Errors.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/09.
//

import Foundation
enum CategoryAddError: Error {
    case noID
    case invalidResponse
}

enum ResourceRequestError: Error {
    case noData
    case decodingError
    case encodingError
}
