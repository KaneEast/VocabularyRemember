//
//  LoginScreen.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/03.
//

import SwiftUI

enum AuthState {
    case signUp // login
    case signIn // register
}

struct LoginScreen: View {
    @State var authState: AuthState = .signUp
    @State var username = ""
    @State var password = ""
    @State var confirmPassword = ""
    @State private var email = ""
    @State private var requestError = false
    @State private var validationError = false
    @EnvironmentObject var auth: Auth
    
    var body: some View {
        VStack(spacing: 55) {
            Text("Wordsgram")
            
            LazyVGrid(columns: gridColums) {
                Text("Username")
                TextField("Username", text: $username)
                .textContentType(.username)
                .autocapitalization(.none)
                
                Text("Password")
                SecureField("Password", text: $password).textContentType(.password)
                
                if authState == .signUp {
                    Text("Confirm Password")
                    SecureField("Confirm Password", text: $confirmPassword).textContentType(.password)
                }
                
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .alert(isPresented: $validationError) {
                if authState == .signUp {
                    return Alert(title: Text("Please complete the username, password, and confirm password fields"))
                } else {
                    return Alert(title: Text("Please complete the username and password fields"))
                }
            }
            
            VStack(spacing: 8) {
                Button(action: {
                    if authState == .signIn {
                        login()
                    } else {
                        
                    }
                    
                }) {
                    HStack {
                        Spacer()
                        Text(authState == .signUp ? signup : signin)
                            .foregroundColor(.white)
                        Spacer()
                    }
                }
                .padding([.top, .bottom], 10)
                .background(Color.green.opacity(0.2))
                .clipShape(Capsule())
                .alert(isPresented: $requestError) {
                    Alert(title: Text("Login Request Failed."))
                }
                
                Button(action: {
                    withAnimation { toggleState() }
                }) {
                    HStack {
                        Spacer()
                        Text(authState == .signUp ? signin : signup)
                        Spacer()
                    }
                }
                .padding([.top, .bottom], 10)
                .overlay(Capsule().stroke(Color.green, lineWidth: 2))
            }
            .padding(.horizontal, 50)
            .accentColor(.green)
            
            Spacer().frame(minHeight: 0, maxHeight: 100)
            
        }
        .padding(.horizontal)
    }
    
    private func login() {
        guard username.count > 0, password.count > 0 else {
            validationError = true
            return
        }
        
        auth.login(username: username, password: password) { result in
            switch result {
            case .success:
                break
            case .failure:
                DispatchQueue.main.async {
                    self.requestError = true
                }
            }
        }
    }
    
    private func register() {
        
    }
    
    private func toggleState() {
        authState = (authState == .signUp ? .signIn : .signUp)
    }
}

extension LoginScreen {
    var signup: String {
        "Sign Up"
    }
    var signin: String {
        "Sign In"
    }
    var gridColums: [GridItem] {
        [
            GridItem(.flexible(), spacing: 8, alignment: .leading),
            GridItem(.flexible())]
    }
}

#Preview {
    LoginScreen()
}

