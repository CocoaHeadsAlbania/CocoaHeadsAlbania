//
//  AlarmProgressView.swift
//  CocoaHeadsAlbania
//
//  Created by Bruno Frani on 12.7.25.
//  Copyright © 2025 CocoaHeads Albania. All rights reserved.
//

import SwiftUI
import ActivityKit
import AlarmKit

struct AlarmProgressView: View {
    
    var eventType: EventData.EventType?
    var mode: AlarmPresentationState.Mode
    var tint: Color
    
    var body: some View {
        Group {
            switch mode {
            case .countdown(let countdown):
                ProgressView(
                    timerInterval: Date.now ... countdown.fireDate,
                    countsDown: true,
                    label: { EmptyView() },
                    currentValueLabel: {
                        Image(systemName: eventType?.rawValue ?? "")
                            .scaleEffect(0.9)
                    })
            case .paused(let pausedState):
                let remaining = pausedState.totalCountdownDuration - pausedState.previouslyElapsedDuration
                ProgressView(value: remaining,
                             total: pausedState.totalCountdownDuration,
                             label: { EmptyView() },
                             currentValueLabel: {
                    Image(systemName: "pause.fill")
                        .scaleEffect(0.8)
                })
            default:
                EmptyView()
            }
        }
        .progressViewStyle(.circular)
        .foregroundStyle(tint)
        .tint(tint)
    }
}

#Preview {
//    AlarmProgressView(mode: <#AlarmPresentationState.Mode#>, tint: <#Color#>)
}
