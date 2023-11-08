//
//  RootView.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/03.
//

import SwiftUI

struct RootView: View {
    @State private var selection: AppTab? = .words
    @EnvironmentObject var auth: Auth
    
    var body: some View {
        if auth.isLoggedIn {
            AppTabView(selection: $selection)
        } else {
            LoginView()
        }
    }
}

struct RootScreen_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
