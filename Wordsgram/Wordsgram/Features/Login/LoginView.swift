//
//  LoginView.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/03.
//

import SwiftUI
import Combine

enum AuthActionState: String {
    case SignUp // login
    case SignIn // register
}

struct LoginView: View {
    @EnvironmentObject var authService: AuthService
    @EnvironmentObject var appState: AppState
    @StateObject private var vm = LoginViewModel()
    //    @State private var requestError = false
    //    @State private var validationError = false
    @State private var signInSucces = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HeaderView("Wordsgram", subtitle: "Introduction", desc: "")
                .frame(maxWidth: .infinity)
            
            Picker("authState", selection: $vm.authState) {
                ForEach(vm.authStates, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            GroupBox(FieldType.username.headerText) {
                HStack {
                    TextField(FieldType.username.placeHolderText, text: $vm.username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.system(size: 16, weight: .medium, design: .default))
                    Text(vm.usernameValidation).font(.subheadline)
                }
            }
            
            if vm.authState == .SignIn {
                GroupBox(FieldType.name.headerText) {
                    HStack {
                        TextField(FieldType.name.placeHolderText, text: $vm.name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.system(size: 16, weight: .medium, design: .default))
                        Text(vm.nameValidation).font(.subheadline)
                    }
                }
            }
            
            GroupBox(FieldType.password.headerText) {
                HStack {
                    SecureField(FieldType.password.placeHolderText, text: $vm.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.system(size: 16, weight: .medium, design: .default))
                    Text(vm.passwordValidation).font(.subheadline)
                }
            }
            
            HStack {
                Button(
                    action: vm.loginOrRegister,
                    label: {
                        Text(vm.authState == .SignIn ? "Sign In" : "Sign Up")
                    }
                ).modifier(MainButton())
                
                Button(
                    action: {
                        appState.isNoLoginMode = true
                    },
                    label: {
                        Text("Just Use")
                    }
                ).modifier(MainButton())
            }
            .frame(height: 44)
            
            Spacer()
        }
        .padding()
        .alert(item: $vm.alertType) { alertType in
            alertType.alert
        }
    }
    
}

#Preview {
    LoginView()
}

