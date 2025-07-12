//
//  AlarmControls.swift
//  CocoaHeadsAlbania
//
//  Created by Bruno Frani on 12.7.25.
//  Copyright © 2025 CocoaHeads Albania. All rights reserved.
//


import SwiftUI
import AlarmKit

struct AlarmControls: View {
    var presentation: AlarmPresentation
    var state: AlarmPresentationState
    
    var body: some View {
        HStack(spacing: 4) {
            switch state.mode {
            case .countdown:
                ButtonView(config: presentation.countdown?.pauseButton, intent: PauseIntent(alarmID: state.alarmID.uuidString), tint: .orange)
            case .paused:
                ButtonView(config: presentation.paused?.resumeButton, intent: ResumeIntent(alarmID: state.alarmID.uuidString), tint: .orange)
            default:
                EmptyView()
            }

            ButtonView(config: presentation.alert.stopButton, intent: StopIntent(alarmID: state.alarmID.uuidString), tint: .red)
        }
    }
}

#Preview {
//    AlarmControls(presentation: <#T##AlarmPresentation#>, state: <#T##AlarmPresentationState#>)
}
