//
//  HomeViewModel.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/03.
//

import Foundation

class HomeViewModel: ObservableObject {

    func logout() {
        Auth.shared.logout()
    }
}
