//
//  LoginViewModel.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/03.
//

import Foundation

class LoginViewModel: ObservableObject {

    @Published var username: String = ""
    @Published var password: String = ""

    func login() {
//        LoginAction(
//            parameters: LoginRequest(
//                username: username,
//                password: password
//            )
//        ).call { _ in
//            // Login successful, navigate to the Home screen
//        }
        
//        Auth.shared.setCredentials(
//                        accessToken: response.data.accessToken,
//                        refreshToken: response.data.refreshToken
//                    )
    }
}
