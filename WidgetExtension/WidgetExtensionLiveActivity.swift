//
//  WidgetExtensionLiveActivity.swift
//  WidgetExtension
//
//  Created by Bruno Frani on 12.7.25.
//  Copyright © 2025 CocoaHeads Albania. All rights reserved.
//

import AlarmKit
import SwiftUI
import WidgetKit


struct WidgetExtensionLiveActivity: Widget {
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: AlarmAttributes<EventData>.self) { context in
            // The Lock Screen presentation.
            LockScreenView(attributes: context.attributes, state: context.state)
        } dynamicIsland: { context in
            // The presentations that appear in the Dynamic Island.
            DynamicIsland {
                // The expanded Dynamic Island presentation.
                DynamicIslandExpandedRegion(.leading) {
                    AlarmTitleView(attributes: context.attributes, state: context.state)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    EventTypeView(metadata: context.attributes.metadata)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    BottomView(attributes: context.attributes, state: context.state)
                }
            } compactLeading: {
                // The compact leading presentation.
                CountdownView(state: context.state, maxWidth: 44)
                    .foregroundStyle(context.attributes.tintColor)
            } compactTrailing: {
                // The compact trailing presentation.
                AlarmProgressView(eventType: context.attributes.metadata?.eventType,
                                  mode: context.state.mode,
                                  tint: context.attributes.tintColor)
            } minimal: {
                // The minimal presentation.
                AlarmProgressView(eventType: context.attributes.metadata?.eventType,
                                  mode: context.state.mode,
                                  tint: context.attributes.tintColor)
            }
            .keylineTint(context.attributes.tintColor)
        }
    }
    
}
