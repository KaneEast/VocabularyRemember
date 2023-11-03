//
//  APIError.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/03.
//

import Foundation

enum APIError: String, Error {
    case response
    case noInternet
}

enum ResourceRequestError: String, Error {
    case noData
    case decodingError
    case encodingError
}

enum CategoryAddError: String, Error {
    case noID
    case invalidResponse
}
