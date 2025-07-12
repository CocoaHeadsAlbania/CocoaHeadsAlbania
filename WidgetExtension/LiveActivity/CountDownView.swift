//
//  CountdownView.swift
//  CocoaHeadsAlbania
//
//  Created by Bruno Frani on 12.7.25.
//  Copyright © 2025 CocoaHeads Albania. All rights reserved.
//

import SwiftUI
import AlarmKit

struct CountdownView: View {
    
    var state: AlarmPresentationState
    var maxWidth: CGFloat = .infinity
    
    var body: some View {
        Group {
            switch state.mode {
            case .countdown(let countdown):
                Text(timerInterval: Date.now ... countdown.fireDate, countsDown: true)
            case .paused(let state):
                let remaining = Duration.seconds(state.totalCountdownDuration - state.previouslyElapsedDuration)
                let pattern: Duration.TimeFormatStyle.Pattern = remaining > .seconds(60 * 60) ? .hourMinuteSecond : .minuteSecond
                Text(remaining.formatted(.time(pattern: pattern)))
                
            default:
                EmptyView()
            }
        }
        .monospacedDigit()
        .lineLimit(1)
        .minimumScaleFactor(0.6)
        .frame(maxWidth: maxWidth, alignment: .leading)
    }
}

#Preview {
//    CountdownView()
}

