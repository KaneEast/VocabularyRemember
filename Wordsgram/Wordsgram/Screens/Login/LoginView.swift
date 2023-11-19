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
      
      TextField(FieldType.username.placeHolderText, text: $vm.username)
        .padding()
        .background(vm.usernameValidationColor, in: .rect(cornerRadius: 8).stroke())
        .padding()
      
      if vm.authState == .SignIn {
        TextField(FieldType.name.placeHolderText, text: $vm.name)
          .padding()
          .background(vm.nameValidationColor, in: .rect(cornerRadius: 8).stroke())
          .padding()
      }
      
      SecureField(FieldType.password.placeHolderText, text: $vm.password)
        .padding()
        .background(vm.passwordValidationColor, in: .rect(cornerRadius: 8).stroke())
        .padding()
      
      HStack {
        Button(
          action: vm.loginOrRegister,
          label: {
            Text(vm.authState == .SignIn ? "Sign In" : "Sign Up")
          }
        ).modifier(MainButton())
        
        Button(
          action: {
            appState.isNoUser = true
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

