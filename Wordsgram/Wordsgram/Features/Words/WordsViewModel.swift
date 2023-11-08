//
//  WordNavigationStackViewModel.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/08.
//

import SwiftUI
import Combine
import Moya
import RxMoya
import CombineMoya

class WordsViewModel: ObservableObject {
    
    @Published var requestError = false
    @Published var words: [Word] = []
    
    init() {
        
    }
    
    func getAllWords() {
        
        let provider = MoyaProvider<WGService>()
        provider.rx.request(.requestWords)
            .filterSuccessfulStatusCodes()
            .map([Word].self)
            .subscribe { event in
                switch event {
                case let .success(words):
                    self.words = words
                case .failure(let error):
                    print(error.localizedDescription)
                    self.requestError = true
                }
            }//.dispose()
    }
    
    func deleteOne() {
        
    }
}
