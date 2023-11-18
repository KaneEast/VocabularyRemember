//
//  LoginViewModel.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/08.
//

import SwiftUI
import Combine
import Observation

enum FieldType {
    case username
    case password
    case name
    
    var headerText: String {
        switch self {
        case .username:
            "username"
        case .password:
            "password"
        case .name:
            "name"
        }
    }
    
    var placeHolderText: String {
        switch self {
        case .username:
            "username"
        case .password:
            "password"
        case .name:
            "name"
        }
    }
}

@Observable
class LoginViewModel: ObservableObject {
    
    struct FormField: Identifiable {
        var id = UUID()
        var fieldType: FieldType
        var validation: String = ""
    }
    
    var authState: AuthActionState = .SignUp
    var authStates = [AuthActionState.SignUp, AuthActionState.SignIn]
    
    var name = "" {
        didSet {
            nameValidationColor = name.isEmpty ? .red : .green
        }
    }
    
    var username = "" {
        didSet {
            usernameValidationColor = username.isEmpty ? .red : .green
        }
    }
    
    var password = "" {
        didSet {
            passwordValidationColor = password.isEmpty ? .red : .green
        }
    }
    
    var nameValidationColor = Color.gray
    var usernameValidationColor = Color.gray
    var passwordValidationColor = Color.gray
    
//    @Published var usernameValidation: String = ""
//    @Published var passwordValidation: String = ""
    
    private var requestError = false
    private var validationError = false
    private var signInSucces = false
    
    
    var formFields: [FormField] = [FormField(fieldType: .username), FormField(fieldType: .password)]
    var alertType: AlertType? = nil
    
//    var validationCancellables: Set<AnyCancellable> = []

    init() {
//        $name
//            .map { $0.isEmpty ? "❌" : "✅" }
//            .sink { [unowned self] value in
//                self.nameValidation = value
//            }
//            .store(in: &validationCancellables)
//        
//        $username
//            .map { $0.isEmpty ? "❌" : "✅" }
//            .sink { [unowned self] value in
//                self.usernameValidation = value
//            }
//            .store(in: &validationCancellables)
//        
//        $password
//            .map { $0.isEmpty ? "❌" : "✅" }
//            .sink { [unowned self] value in
//                self.passwordValidation = value
//            }
//            .store(in: &validationCancellables)
    }
    
    func loginOrRegister() {
        Task {
            do {
                if authState == .SignUp {
                    guard username.count > 0, password.count > 0 else {
                        throw AppError.validationError
                    }
                    try await AuthService.shared.login(username: username, password: password)
//                    try await NewAuthService(networkClient: RWAPI(authToken: AuthService.shared.token ?? "")).login(username: username, password: password)
                } else {
                    guard name.count > 0, password.count > 0, username.count > 0 else {
                        throw AppError.validationError
                    }
                    try await AuthService.shared.register(name: name, username: username, password: password)
                }
            } catch {
                await MainActor.run {
                    self.alertType = .choice(primaryAction: {
                        print("primaryAction")
                    }, secondaryAction: {
                        print("secondaryAction")
                    })
                }
            }
            
        }
    }
}

