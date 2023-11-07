//
//  LoginView.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/03.
//

import SwiftUI

enum AuthState: String {
    case SignUp // login
    case SignIn // register
}

struct LoginView: View {
    @StateObject private var vm = LoginViewModel()
    
//    @State var authState: AuthState = .signUp
    
    @State private var requestError = false
    @State private var validationError = false
    @State private var signInSucces = false
//    @EnvironmentObject var auth: Auth
    
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HeaderView("Wordsgram", subtitle: "Introduction", desc: "")
            .frame(maxWidth: .infinity)
            
            Section {
                TextField(FieldType.username.placeHolderText, text: $vm.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: 24, weight: .medium, design: .default))
            } header: {
                Text(FieldType.username.headerText).font(.subheadline)
            } footer: {
                Text(vm.usernameValidation).font(.subheadline)
            }
            
            if vm.authState == .SignIn {
                Section {
                    TextField(FieldType.name.placeHolderText, text: $vm.name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.system(size: 24, weight: .medium, design: .default))
                } header: {
                    Text(FieldType.name.headerText).font(.subheadline)
                } footer: {
                    Text(vm.nameValidation).font(.subheadline)
                }
            }
            
            Section {
                SecureField(FieldType.password.placeHolderText, text: $vm.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: 24, weight: .medium, design: .default))
                
            } header: {
                Text(FieldType.password.headerText).font(.subheadline)
            } footer: {
                Text(vm.passwordValidation).font(.subheadline)
            }
            
            
            Button(
                action: vm.loginOrRegister,
                label: {
                    Text(vm.authState == .SignIn ? "Sign Ip" : "Sign Up")
                        .modifier(MainButton())
                }
            )
            
            Picker("authState", selection: $vm.authState) {
                ForEach(vm.authStates, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Spacer()
        }
        .padding()
        
        
        
        //        VStack(spacing: 20) {
        //            HeaderView("Wordsgram",
        //                       subtitle: "Introduction",
        //                       desc: "You can use the store function at the end of a pipeline to add your pipeline's cancellable to a Set.")
        //
        //            Group {
        //                HStack {
        //                    TextField("name", text: $vm.name)
        //                        .textFieldStyle(RoundedBorderTextFieldStyle())
        //                    Text(vm.nameValidation)
        //                }
        //
        //                HStack {
        //                    TextField("user name", text: $vm.username)
        //                        .textFieldStyle(RoundedBorderTextFieldStyle())
        //                    Text(vm.usernameValidation)
        //                }
        //
        //                HStack {
        //                    SecureField("password", text: $vm.password)
        //                        .textFieldStyle(RoundedBorderTextFieldStyle())
        //                    Text(vm.usernameValidation)
        //                }
        //            }
        //            .padding()
        //        }
        //        .font(.title)
        //        VStack(spacing: 55) {
        //
        //            LazyVGrid(columns: gridColums) {
        //
        //
        //                Text("Name")
        //                TextField("Name", text: $name)
        //                .textContentType(.username)
        //                .autocapitalization(.none)
        //
        //                if authState == .signIn {
        //                    Text("User Name")
        //                    TextField("User Name", text: $username)
        //                    .textContentType(.username)
        //                    .autocapitalization(.none)
        //                }
        //
        //                Text("Password")
        //                SecureField("Password", text: $password).textContentType(.password)
        //            }
        //            .textFieldStyle(RoundedBorderTextFieldStyle())
        //            .alert(isPresented: $validationError) {
        //                if authState == .signUp {
        //                    return Alert(title: Text("Please complete the username, password, and confirm password fields"))
        //                } else {
        //                    return Alert(title: Text("Please complete the username and password fields"))
        //                }
        //            }
        //
        //            VStack(spacing: 8) {
        //                Button(action: {
        //                    if authState == .signIn {
        //                        register()
        //                    } else {
        //                        login()
        //                    }
        //
        //                }) {
        //                    HStack {
        //                        Spacer()
        //                        Text(authState == .signUp ? signup : signin)
        //                            .foregroundColor(.white)
        //                        Spacer()
        //                    }
        //                }
        //                .padding([.top, .bottom], 10)
        //                .background(Color.green.opacity(0.2))
        //                .clipShape(Capsule())
        //                .alert(isPresented: $requestError) {
        //                    Alert(title: Text("Login Request Failed."))
        //                }
        //                .alert(isPresented: $signInSucces) {
        //                    Alert(title: Text("Succesfully Signed In. Please Login"))
        //                }
        //
        //                Button(action: {
        //                    withAnimation { toggleState() }
        //                }) {
        //                    HStack {
        //                        Spacer()
        //                        Text(authState == .signUp ? signin : signup)
        //                        Spacer()
        //                    }
        //                }
        //                .padding([.top, .bottom], 10)
        //                .overlay(Capsule().stroke(Color.green, lineWidth: 2))
        //            }
        //            .padding(.horizontal, 50)
        //            .accentColor(.green)
        //
        //            Spacer().frame(minHeight: 0, maxHeight: 100)
        //
        //        }
        //        .padding(.horizontal)
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

