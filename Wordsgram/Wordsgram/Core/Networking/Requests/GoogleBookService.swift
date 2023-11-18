//
//  GoogleBookService.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/16.
//
//
//import Foundation
//
//enum GoogleBookService {
//    case queryBook(title: String, author: String)
//}
//
//// MARK: - TargetType Protocol Implementation
//extension GoogleBookService: TargetType {
//    var baseURL: URL { URL(string: "https://www.googleapis.com/books/v1")! }
//    var path: String {
//        switch self {
//        case let .queryBook(title, author):
//            return "/volumes?q=/\(title)/+inauthor:/\(author)&key=AIzaSyD6HIRAMsM7jI3p4rVYQ03DjXLlYlNzJGs"
//        }
//    }
//    var method: Moya.Method {
//        switch self {
//        case .queryBook:
//            return .get
//        }
//    }
//    var task: Task {
//        switch self {
//        case .queryBook:
//            return .requestPlain
//        }
//    }
//    
//    var headers: [String: String]? {
//        switch self {
//        default:
//            return ["Content-type": "application/json"]
//        }
//        
//    }
//}
//
//// MARK: - Helpers
//private extension String {
//    var urlEscaped: String {
//        addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
//    }
//
//    var utf8Encoded: Data { Data(self.utf8) }
//}
//
