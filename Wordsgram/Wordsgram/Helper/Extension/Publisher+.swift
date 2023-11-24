import Combine

extension Publisher {
  func asyncValue(storeIn cancellables: inout Set<AnyCancellable>) async throws -> Output {
    try await withCheckedThrowingContinuation { continuation in
      self.sink(
        receiveCompletion: { completion in
          switch completion {
          case .finished:
            break
          case .failure(let error):
            continuation.resume(throwing: error)
          }
        },
        receiveValue: { value in
          continuation.resume(returning: value)
        }
      )
      .store(in: &cancellables)
    }
  }
}
