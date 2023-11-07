//
//  LoginScreen.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/03.
//


import SwiftUI

enum AuthState {
  case signUp
  case signIn
}

struct LoginScreen: View {
    @State var authState: AuthState = .signUp
    @State var username = ""
    @State var password = ""
    @State private var email = ""
    @State private var requestError = false
    @State private var validationError = false
    @EnvironmentObject var auth: Auth
//    @ObservedObject var viewModel: LoginViewModel = LoginViewModel()
    
    var body: some View {
        VStack(spacing: 55) {
          Text("Wordsgram")

          let columns: [GridItem] = [
            GridItem(.flexible(), spacing: 8, alignment: .leading),
            GridItem(.flexible())
          ]

          LazyVGrid(columns: columns) {
            Text("Username")
            TextField("Username", text: $username)
              .textContentType(.username)
              .autocapitalization(.none)
            if authState == .signUp {
              Text("Email")
              TextField("Email", text: $email)
                .textContentType(.emailAddress)
            }
            Text("Password")
            SecureField("Password", text: $password)
              .textContentType(.password)
          }
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .alert(isPresented: $validationError) {
            if authState == .signUp {
              return Alert(title: Text("Please complete the username, email, and password fields"))
            } else {
              return Alert(title: Text("Please complete the username and password fields"))
            }
          }

          VStack(spacing: 8) {
            Button(action: {
                login()
            }) {
              HStack {
                Spacer()
                Text(authState == .signUp ? "Sign Up" : "Sign In")
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
                Text(authState == .signUp ? "Sign In" : "Sign Up")
                Spacer()
              }
            }
            .padding([.top, .bottom], 10)
            .overlay(Capsule().stroke(Color.green, lineWidth: 2))
          }
          .padding(.horizontal, 50)
          .accentColor(.green)

          Spacer()
            .frame(minHeight: 0, maxHeight: 100)

        }
        .padding(.horizontal)
//        VStack {
//            Spacer()
//            
//            VStack {
//                TextField("Login", text: $username)
//                    .autocapitalization(.none)
//                    .disableAutocorrection(true)
//                    .padding(.top, 20)
//                
//                Divider()
//                
//                SecureField("Password", text: $password)
//                    .padding(.top, 20)
//                
//                Divider()
//            }
//            
//            Spacer()
//            
//            Button(
//                action: login,
//                label: {
//                    Text("LoginButton")
//                        .modifier(MainButton())
//                }
//            )
//        }
//        .padding(30)
//        .alert(isPresented: $requestError) {
//            Alert(title: Text("Error"), message: Text("Could not log in. Check your credentials and try again"))
//        }
    }
    
    func login() {
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
    
    private func toggleState() {
      authState = (authState == .signUp ? .signIn : .signUp)
    }
}

#Preview {
    LoginScreen()
}

