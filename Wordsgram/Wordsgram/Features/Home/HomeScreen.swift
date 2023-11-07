//
//  HomeScreen.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/03.
//

import SwiftUI

struct HomeScreen: View {
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Home.Title")
                .font(.system(size: 24, weight: .bold, design: .default))
            
            Spacer()
            
            Button(
                action: logout,
                label: {
                    Text("Home.LogoutButton.Title")
                    .modifier(MainButton(color: Color.red))
                }
            )
        }
        .padding(30)
    }
    
    private func logout() {
        Auth.shared.logout()
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
