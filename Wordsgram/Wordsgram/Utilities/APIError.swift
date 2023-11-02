//
//  APIError.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/03.
//

import Foundation

enum APIError: String, Error {
    case jsonDecoding
    case response
    case noInternet
}
