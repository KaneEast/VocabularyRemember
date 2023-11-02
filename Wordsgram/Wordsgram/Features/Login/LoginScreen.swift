//
//  LoginScreen.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/03.
//


import SwiftUI

struct LoginScreen: View {
    
    @ObservedObject var viewModel: LoginViewModel = LoginViewModel()
    
    var body: some View {
        VStack {
            
            Spacer()
            
            VStack {
                TextField("Login", text: $viewModel.username)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.top, 20)
                
                Divider()
                
                SecureField("Password", text: $viewModel.password)
                    .padding(.top, 20)
                
                Divider()
            }
            
            Spacer()
            
            Button(
                action: viewModel.login,
                label: {
                    Text("LoginButton")
                        .modifier(MainButton())
                }
            )
        }
        .padding(30)
    }
}

#Preview {
    LoginScreen()
}

