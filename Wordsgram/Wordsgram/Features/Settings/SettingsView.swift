//
//  HomeScreen.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/03.
//

import SwiftUI

struct SettingsView: View {
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Text("Home.Title")
                    .font(.system(size: 24, weight: .bold, design: .default))
                
                Spacer()
                
                Button(
                    action: signOut,
                    label: {
                        Text("Sign Out")
                            .modifier(MainButton(color: Color.red))
                    }
                )
            }
            .padding(30)
            .navigationTitle("Settings")
        }
    }
    
    private func signOut() {
        Auth.shared.signOut()
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
