//
//  AlarmTitleView.swift
//  CocoaHeadsAlbania
//
//  Created by Bruno Frani on 12.7.25.
//  Copyright © 2025 CocoaHeads Albania. All rights reserved.
//

import SwiftUI
import AlarmKit

struct AlarmTitleView: View {
    
    var attributes: AlarmAttributes<EventData>
    
    var state: AlarmPresentationState
    
    var body: some View {
        let title: LocalizedStringResource? = switch state.mode {
        case .countdown:
            attributes.presentation.countdown?.title
        case .paused:
            attributes.presentation.paused?.title
        case .alert:
            attributes.presentation.alert.title
        default:
            nil
        }
        
        Text(title ?? "")
            .font(.title3)
            .fontWeight(.semibold)
            .lineLimit(1)
            .padding(.leading, 6)
    }
}

#Preview {
//    AlarmTitleView()
}
