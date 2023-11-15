//
//  UIApplication+DismissKeyboard.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/15.
//

import UIKit

extension UIApplication {
    static func dismissKeyboard() {
        shared.dismissKeyboard()
    }
    
    private func dismissKeyboard() {
        sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
