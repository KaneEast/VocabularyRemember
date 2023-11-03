//
//  LoginScreen.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/03.
//


import SwiftUI

struct LoginScreen: View {
    @State var username = ""
    @State var password = ""
    @State private var showingLoginErrorAlert = false
    @EnvironmentObject var auth: Auth
//    @ObservedObject var viewModel: LoginViewModel = LoginViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack {
                TextField("Login", text: $username)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.top, 20)
                
                Divider()
                
                SecureField("Password", text: $password)
                    .padding(.top, 20)
                
                Divider()
            }
            
            Spacer()
            
            Button(
                action: login,
                label: {
                    Text("LoginButton")
                        .modifier(MainButton())
                }
            )
        }
        .padding(30)
        .alert(isPresented: $showingLoginErrorAlert) {
            Alert(title: Text("Error"), message: Text("Could not log in. Check your credentials and try again"))
        }
    }
    
    func login() {
        auth.login(username: username, password: password) { result in
            switch result {
            case .success:
                break
            case .failure:
                DispatchQueue.main.async {
                    self.showingLoginErrorAlert = true
                }
            }
        }
    }
}

#Preview {
    LoginScreen()
}

