//
//  WordsgramUITests.swift
//  WordsgramUITests
//
//  Created by Kane on 2023/11/26.
//

import XCTest

final class WordsgramUITests: XCTestCase {
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testExample() throws {
    // UI tests must launch the application that they test.
    let app = XCUIApplication()
    app.launch()
    // after break point breaked Enter: po app
    /**
     Attributes: Application, 0x1011061f0, pid: 7561, label: 'WordsgramDev'
     Element subtree:
      →Application, 0x1011061f0, pid: 7561, label: 'WordsgramDev'
         Window (Main), 0x1011095d0, {{0.0, 0.0}, {375.0, 812.0}}
           Other, 0x1011059e0, {{0.0, 0.0}, {375.0, 812.0}}
             Other, 0x101106610, {{0.0, 0.0}, {375.0, 812.0}}
               Other, 0x101505d60, {{0.0, 0.0}, {375.0, 812.0}}
                 Other, 0x10150c280, {{0.0, 0.0}, {375.0, 812.0}}
                   Other, 0x10150ca90, {{0.0, 0.0}, {375.0, 812.0}}
                     Other, 0x10150cbb0, {{0.0, 0.0}, {375.0, 812.0}}
                       Other, 0x10150d810, {{0.0, 0.0}, {375.0, 812.0}}
                         Other, 0x10150d930, {{0.0, 0.0}, {375.0, 812.0}}
                           Other, 0x10150a4a0, {{0.0, 0.0}, {375.0, 812.0}}
                             Other, 0x10150a5c0, {{0.0, 0.0}, {375.0, 812.0}}
                               Other, 0x10150a6e0, {{0.0, 0.0}, {375.0, 812.0}}
                                 NavigationBar, 0x10150a800, {{0.0, 50.0}, {375.0, 148.0}}, identifier: 'Books'
                                   Other, 0x10150a920, {{275.0, 55.0}, {42.0, 34.0}}, label: 'Add'
                                     Other, 0x10150aa40, {{275.0, 55.0}, {42.0, 34.0}}
                                       Button, 0x10150ab60, {{275.0, 55.0}, {42.0, 34.0}}, label: 'Add'
                                   Other, 0x10150ac80, {{325.0, 55.0}, {34.0, 34.0}}, label: 'Filter'
                                     Other, 0x10150ada0, {{325.0, 55.0}, {34.0, 34.0}}
                                       Button, 0x10150aec0, {{325.0, 55.0}, {34.0, 34.0}}, label: 'Filter'
                                         Button, 0x10150afe0, {{325.0, 55.0}, {34.0, 34.0}}
                                           Other, 0x10150b100, {{325.0, 55.0}, {34.0, 34.0}}
                                             Image, 0x10150b220, {{325.0, 55.0}, {34.0, 34.0}}, label: 'Filter'
                                   StaticText, 0x10150b340, {{16.0, 97.7}, {98.3, 40.7}}, label: 'Books'
                                   SearchField, 0x10150b460, {{16.0, 147.0}, {343.0, 36.0}}, label: 'Search book title', placeholderValue: 'Search book title'
                                 Other, 0x10150e940, {{0.0, 0.0}, {375.0, 812.0}}
                                   Other, 0x10150ea60, {{0.0, 0.0}, {375.0, 812.0}}
                                     Other, 0x10150eb80, {{0.0, 0.0}, {375.0, 812.0}}
                                       Other, 0x10150eca0, {{0.0, 0.0}, {375.0, 812.0}}
                                         CollectionView, 0x10150edc0, {{0.0, 0.0}, {375.0, 812.0}}
                                           Other, 0x10150eee0, {{0.0, -1426.0}, {375.0, 3964.0}}
                                           Cell, 0x10150f000, {{0.0, 198.0}, {375.0, 112.0}}
                                             Other, 0x10150f120, {{0.0, 198.0}, {375.0, 112.0}}
                                               Other, 0x10150f240, {{0.0, 198.0}, {375.0, 112.0}}
                                             Other, 0x10150f360, {{0.0, 198.0}, {375.0, 112.0}}
                                               Other, 0x10150f480, {{0.0, 198.0}, {375.0, 112.0}}
                                                 Other, 0x10150f5a0, {{0.0, 198.0}, {375.0, 112.0}}
                                                   Button, 0x10150f6c0, {{0.0, 198.0}, {375.0, 112.0}}, label: 'Brave New World, Author: Aldous huxley, Published on: 1932'
                                                     Image, 0x10150f7e0, {{31.7, 209.0}, {58.7, 90.0}}
                                                     StaticText, 0x10150f900, {{114.0, 209.0}, {136.0, 20.3}}, label: 'Brave New World'
                                                     StaticText, 0x10150fa20, {{114.0, 232.0}, {132.7, 15.7}}, label: 'Author: Aldous huxley'
                                                     StaticText, 0x10150fb40, {{114.0, 250.3}, {115.7, 15.7}}, label: 'Published on: 1932'
                                                     Image, 0x10150fc60, {{351.3, 248.0}, {7.0, 12.0}}
                                           Other, 0x10150fd80, {{16.0, 198.0}, {359.0, 0.3}}
                                           Cell, 0x10150fea0, {{0.0, 310.0}, {375.0, 112.0}}
     */
    print(app)
    
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }
  
  func testLaunchPerformance() throws {
    if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
      // This measures how long it takes to launch your application.
      measure(metrics: [XCTApplicationLaunchMetric()]) {
        XCUIApplication().launch()
      }
    }
  }
}
