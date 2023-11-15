//
//  WidgetExtensionBundle.swift
//  WidgetExtension
//
//  Created by Kane on 2023/11/15.
//

import WidgetKit
import SwiftUI

@main
struct WidgetExtensionBundle: WidgetBundle {
    var body: some Widget {
        WidgetExtension()
        WidgetExtensionLiveActivity()
    }
}
