//
//  WordsService.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/09.
//

import SwiftUI
import Combine

class WordsService: ObservableObject {
    @Published var words = [Word]()
    var total: Int {
        words.count
    }
    var cancellables = Set<AnyCancellable>()
    
    init(words: [Word] = [Word]()) {
        self.words = words
    }
    
    func fetchAllFromServer() async throws {
        let requestWordsRequest = RequestWordsRequest()
        requestWordsRequest.request()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                }
            }, receiveValue: { words in
                self.words = words
            })
            .store(in: &cancellables)
    }
    
    func createWord() async throws {
        let createWordRequest = CreateWordRequest(CreateWordParam(name: "New Word", meaning: "Definition"))
        createWordRequest.request()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                }
            }, receiveValue: {_ in
                // TODO: show hud
            })
            .store(in: &cancellables)
    }
}
