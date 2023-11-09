//
//  CategoriesService.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/10.
//

import SwiftUI
import RxMoya
import RxSwift

import CombineMoya
import Combine

class CategoriesService: ObservableObject {
    @Published var detailedCategories = [CategoryWithWordResponse]()
    @Published var categories = [Category]()
    
    var total: Int {
        detailedCategories.count
    }
    
    private let disposeBag = DisposeBag()
    
    func fetchAllFromServer() async throws {
        let results: [CategoryWithWordResponse] = try await  WGProviderFactory.shared.requestPublisher(.getAllCategoriesWords)
            .filterSuccessfulStatusCodes()
            .map([CategoryWithWordResponse].self)
            .asyncValue()
        await MainActor.run {
            self.detailedCategories = results
        }
    }
    
    func fetchCategories() async throws {
        let results: [Category] = try await  WGProviderFactory.shared.requestPublisher(.requestCategories)
            .filterSuccessfulStatusCodes()
            .map([Category].self)
            .asyncValue()
        await MainActor.run {
            self.categories = results
            
        }
    }
    
    func saveCategory(name: String) async throws -> Category {
//        guard name.count > 0 else {
//            throw error
//        }
        
        return try await  WGProviderFactory.shared.requestPublisher(.createCategory(name: name))
            .filterSuccessfulStatusCodes()
            .map(Category.self)
            .asyncValue()
    }
    
    func getCategoryOfWord(wordID: UUID) {
        WGProviderFactory.shared.rx.request(.getCategoryOfWord(wordID: wordID.uuidString))
            .filterSuccessfulStatusCodes()
            .map([Category].self)
            .subscribe { event in
                switch event {
                case .success(let categories):
                    print(categories)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
}
