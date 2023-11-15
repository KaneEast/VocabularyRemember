//
//  WordsService.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/09.
//

import SwiftUI
import CombineMoya
import Combine

class WordsService: ObservableObject {
    @Published var words = [Word]()
    var total: Int {
        words.count
    }
    
    init(words: [Word] = [Word]()) {
        self.words = words
    }
    
    func fetchAllFromServer() async throws {
        let words: [Word] = try await  WGProviderFactory.shared.requestPublisher(.requestWords)
            .filterSuccessfulStatusCodes()
            .map([Word].self)
            .asyncValue()
        await MainActor.run {
            self.words = words
        }
    }
}
