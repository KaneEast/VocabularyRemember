//
//  SettingsOption.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/09.
//

import Foundation
enum SettingsOption: Int, Identifiable, CaseIterable {
    case settings1
    case settings2
    case settings3
    case libraries
    
    var id: Int { rawValue }
    
    var title: String {
        switch self {
        case .settings1:
            return .settings1
        case .settings2:
            return .settings2
        case .settings3:
            return "Country"
        case .libraries:
            return .libraries
        }
    }
    
    var isToggle: Bool {
        switch self {
        default:
            return false
        }
    }
}
