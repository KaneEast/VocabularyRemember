//
//  Router.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/18.
//

import Combine
import Foundation
import Observation
import SwiftUI

public enum RouterDestination: Hashable {
  case bookDetail(book: Book)
  case genreDetail(genre: Genre)
}

public enum SheetDestination: Identifiable {
  case addNewBook
  case addNewGenre
  case createCategory
  
  public var id: String {
    switch self {
    case .addNewBook:
      "addNewBook"
    case .addNewGenre:
      "addNewGenre"
    case .createCategory:
      "createCategory"
    }
  }
}

@MainActor
@Observable public class RouterPath {
  public var urlHandler: ((URL) -> OpenURLAction.Result)?
  
  public var path: [RouterDestination] = []
  public var presentedSheet: SheetDestination?
  
  public init() {}
  
  public func navigate(to: RouterDestination) {
    path.append(to)
  }
  
}

