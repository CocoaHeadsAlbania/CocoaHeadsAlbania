//
//  BottomView.swift
//  CocoaHeadsAlbania
//
//  Created by Bruno Frani on 12.7.25.
//  Copyright © 2025 CocoaHeads Albania. All rights reserved.
//

import SwiftUI
import AppIntents
import AlarmKit


struct BottomView: View {
    
    var attributes: AlarmAttributes<EventData>
    var state: AlarmPresentationState
    
    var body: some View {
       
        HStack {
            CountdownView(state: state, maxWidth: 150)
                .font(.system(size: 40, design: .rounded))
            Spacer()
            AlarmControls(presentation: attributes.presentation, state: state)
        }
    }
}
