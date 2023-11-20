//
//  TabView.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/21.
//

import SwiftUI

struct TabView<
  BookListView: View,
  GenreListView: View,
  SettingsView: View
> {
  init(
    booklistView: @escaping () -> BookListView,
    genreListView: @escaping () -> GenreListView,
    settingsView: @escaping () -> SettingsView
  ) {
    self.booklistView = booklistView
    self.genreListView = genreListView
    self.settingsView = settingsView
  }
  
  @EnvironmentObject private var model: TabViewModel
  //@EnvironmentObject private var settingsManager: SettingsManager
  
  private let booklistView: () -> BookListView
  private let genreListView: () -> GenreListView
  private let settingsView: () -> SettingsView
}

// MARK: - View
extension TabView: View {
  var body: some View {
    ScrollViewReader { proxy in
      SwiftUI.TabView(
        selection: .init(
          get: { model.selectedTab },
          set: { selection in
            switch model.selectedTab {
            case selection:
              if selection == model.selectedTab {
                // empty the Routerpath
              }
              
              withAnimation {
                proxy.scrollTo(
                  TabViewModel.ScrollToTopID(
                    mainTab: selection, detail: model.showingDetailView[selection]!
                  ),
                  anchor: .top
                )
              }
            default:
              model.selectedTab = selection
            }
          }
        )
      ) {
        tab(
          content: booklistView,
          text: .books,
          imageName: "book.pages.fill",
          tab: .books
        )
        
        tab(
          content: genreListView,
          text: .genres,
          imageName: "books.vertical.fill",
          tab: .genres
        )
        
        tab(
          content: settingsView,
          text: .settings,
          imageName: "gearshape.fill",
          tab: .settings
        )
      }
    }
    //.accentColor(.accent)
  }
}

#Preview {
  TabView(
    booklistView: { Text("WORDS") },
    genreListView: { Text("GENRE") },
    settingsView: { Text("SETTINGS") }
  ).environmentObject(TabViewModel())
}


// MARK: - private
private func tab<Content: View>(
  content: () -> Content,
  text: String,
  imageName: String,
  tab: TabViewModel.MainTab
) -> some View {
  NavigationView(content: content)
    .tabItem {
      Text(text)
      //Image(imageName)
      Image(systemName: imageName)
    }
    .tag(tab)
    .environment(\.mainTab, tab) // for constructing `ScrollToTopID`s
    .navigationViewStyle(.stack)
    .accessibility(label: .init(text))
}

