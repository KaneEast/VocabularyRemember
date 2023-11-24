//
//  ModelContainerManager.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/24.
//

import SwiftUI
import SwiftData

let prePopulateGenres = [
  "Science Fiction",
  "Historical Fiction",
  "Health & Fitness",
  "History",
  "Computer Science",
  "Programing",
  "iOS & Swift",
  "Speculative Fiction",
  "Fantasy",
  "Thriller",
  "Crime",
  "Mystery",
  "Horror",
  "Autobiography",
  "Biography",
  "Textbook",
  "Philosophy",
  "Self-Help",
  "Politics",
  "Economics",
]

@MainActor class ModelContainerManager {
  @AppStorage("sampleDataPopulated") var sampleDataAdded: Bool = false
  @AppStorage("previewSampleDataPopulated") var previewSampleDataAdded: Bool = false
  
  let schema = Schema([
    Book.self,
    Note.self,
    Genre.self,
  ])
  
  static var shared = ModelContainerManager()
  private init() {}
  
  lazy var sharedModelContainer: ModelContainer = {
    
    let modelConfiguration = ModelConfiguration(schema: schema,
                                                isStoredInMemoryOnly: false)
    
    do {
      let modelContainer = try ModelContainer(for: schema,
                                              configurations: [modelConfiguration])
      
      if sampleDataAdded {
        return modelContainer
      }
      ModelContainerManager.populateInitialData(modelContainer)
      sampleDataAdded = true
      return modelContainer
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }()
  
  var previewModelContainer: ModelContainer {
    let previewConfiguration = ModelConfiguration(schema: schema,
                                                  isStoredInMemoryOnly: true)
    
    do {
      let modelContainer = try ModelContainer(for: schema,
                                              configurations: [previewConfiguration])
      
      if previewSampleDataAdded {
        return modelContainer
      }
      
      ModelContainerManager.populateInitialData(modelContainer)
      previewSampleDataAdded = true
      return modelContainer
    } catch {
      fatalError("Could not create Preview ModelContainer: \(error)")
    }
  }
  
  // Pre-populating Data
  static func populateInitialData(_ modelContainer: ModelContainer) {
    
    
    var genreFetchDescriptor = FetchDescriptor<Genre>()
    genreFetchDescriptor.fetchLimit = 1
    
    let fetchCount = try? modelContainer.mainContext.fetch(genreFetchDescriptor).count
    guard fetchCount == 0 else {
      return
    }
    
    prePopulateGenres.forEach {
      let genre = Genre(name: $0)
      genre.books = []
      modelContainer.mainContext.insert(genre)
    }
    
    do {
      try modelContainer.mainContext.save()
    } catch {
      print(error.localizedDescription)
    }
  }
}
