//
//  CategoriesService.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/10.
//

import SwiftUI
import Combine

class CategoriesService: ObservableObject {
  @Published var detailedCategories = [CategoryWithWordResponse]()
  @Published var categories = [Category]()
  
  var total: Int {
    detailedCategories.count
  }
  
  var cancellables = Set<AnyCancellable>()
  
  func fetchAllFromServer() async throws {
    let createCategoryRequest = GetAllCategoriesWordsRequest()
    createCategoryRequest.request()
      .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
          break
        case .failure(let error):
          print("Error: \(error)")
        }
      }, receiveValue: { result in
        self.detailedCategories = result
      })
      .store(in: &cancellables)
  }
  
  func fetchCategories() async throws {
    let createCategoryRequest = RequestCategoriesRequest()
    createCategoryRequest.request()
      .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
          break
        case .failure(let error):
          print("Error: \(error)")
        }
      }, receiveValue: { result in
        self.categories = result
      })
      .store(in: &cancellables)
  }
  
  func saveCategory(name: String) async throws {
    let createCategoryRequest = CreateCategoryRequest(CreateCategoryParam(name: name))
    createCategoryRequest.request()
      .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
          break
        case .failure(let error):
          print("Error: \(error)")
        }
      }, receiveValue: {_ in
        // show hud
      })
      .store(in: &cancellables)
  }
  
  func getCategoryOfWord(wordID: UUID) {
    
  }
}
