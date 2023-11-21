//
//  AppState.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/12.
//

import SwiftUI

class AppState: ObservableObject {
    @AppStorage("isNoLoginMode") var isNoUser = false
}
