//
//  ModelRepository.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/19.
//

import Foundation
import SwiftData

struct ModelRepository<Model: PersistentModel> {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func getAll() throws -> [Model] {
        let params = FetchDescriptor<Model>()

        let result = try context.fetch(params)

        return result
    }

    func deleteEntities(_ models: [Model]) {
        for model in models {
            context.delete(model)
        }
    }

    /// Save changes made to the local data store
    func save() throws {
        if context.hasChanges {
            try context.save()
        }
    }

    /// Add models to the local data store
    func create(_ models: [Model]) {
        for model in models {
            context.insert(model)
        }
    }
}
