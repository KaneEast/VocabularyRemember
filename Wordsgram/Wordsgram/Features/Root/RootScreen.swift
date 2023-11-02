//
//  RootScreen.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/03.
//

import SwiftUI

struct RootScreen: View {
    
    @EnvironmentObject var auth: Auth
    
    var body: some View {
        if auth.loggedIn {
            HomeScreen()
        } else {
            LoginScreen()
        }
    }
}

struct RootScreen_Previews: PreviewProvider {
    static var previews: some View {
        RootScreen()
    }
}
