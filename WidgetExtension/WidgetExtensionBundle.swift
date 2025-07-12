//
//  WidgetExtensionBundle.swift
//  WidgetExtension
//
//  Created by Bruno Frani on 12.7.25.
//  Copyright © 2025 CocoaHeads Albania. All rights reserved.
//

import WidgetKit
import SwiftUI

@main
struct WidgetExtensionBundle: WidgetBundle {
    var body: some Widget {
        WidgetExtension()
        WidgetExtensionControl()
        WidgetExtensionLiveActivity()
    }
}
