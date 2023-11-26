//
//  SettingsNavStack.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/26.
//

import Foundation
/// Settings View Nav Stack
enum SettingsStack: String, CaseIterable {
    case myProfile = "My Profile"
    case dataUsage = "Data Usage"
    case privacyPolicy = "Privacy Policy"
    case termsOfService = "Terms Of Service"
    
    static func convert(from: String) -> Self? {
        return self.allCases.first { tab in
            tab.rawValue.lowercased() == from.lowercased()
        }
    }
}
