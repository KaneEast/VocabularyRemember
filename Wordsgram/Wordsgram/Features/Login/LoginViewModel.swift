//
//  LoginViewModel.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/08.
//

import SwiftUI
import Combine
import Moya

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

class LoginViewModel: ObservableObject {
    
    struct FormField: Identifiable {
        var id = UUID()
        var fieldType: FieldType
        var validation: String = ""
    }
    
    @Published var authState: AuthActionState = .SignUp
    @Published var authStates = [AuthActionState.SignUp, AuthActionState.SignIn]
    
    @Published var name: String = ""
    @Published var username = ""
    @Published var password = ""
    
    @Published private var requestError = false
    @Published private var validationError = false
    @Published private var signInSucces = false
    
    @Published var nameValidation: String = ""
    @Published var usernameValidation: String = ""
    @Published var passwordValidation: String = ""
    
    @Published var formFields: [FormField] = [FormField(fieldType: .username), FormField(fieldType: .password)]
    
    var validationCancellables: Set<AnyCancellable> = []

    init() {
        $name
            .map { $0.isEmpty ? "❌" : "✅" }
            .sink { [unowned self] value in
                self.nameValidation = value
            }
            .store(in: &validationCancellables)
        
        $username
            .map { $0.isEmpty ? "❌" : "✅" }
            .sink { [unowned self] value in
                self.usernameValidation = value
            }
            .store(in: &validationCancellables)
        
        $password
            .map { $0.isEmpty ? "❌" : "✅" }
            .sink { [unowned self] value in
                self.passwordValidation = value
            }
            .store(in: &validationCancellables)
    }
    
    func loginOrRegister() {
        if authState == .SignUp {
            login()
        } else {
            register()
        }
    }
    
    private func login() {
        guard name.count > 0, password.count > 0 else {
            validationError = true
            return
        }
        
        let provider = MoyaProvider<WGService>()
        provider.rx.request(.login(username: name, password: password))
            .filterSuccessfulStatusCodes()
            .map(Token.self)
            .subscribe { event in
                switch event {
                case let .success(token):
                    AuthService.shared.token = token.value
                case .failure(let error):
                    print(error.localizedDescription)
                    self.requestError = true
                }
            }//.dispose()
    }
    
    private func register() {
        guard name.count > 0, password.count > 0, username.count > 0 else {
            validationError = true
            return
        }
        
        let provider = MoyaProvider<WGService>()
        provider.request(.createUser(name: name, username: username, password: password)) { result in
            // do something with the result (read on for more details)
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data // Data, your JSON response is probably in here!
                let statusCode = moyaResponse.statusCode // Int - 200, 401, 500, etc
                
                print("Register Successed, Please Login")
                
                // do something in your app
            case let .failure(error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.requestError = true
                }
            }
        }
    }
}

