//
//  EventTypeView.swift
//  CocoaHeadsAlbania
//
//  Created by Bruno Frani on 12.7.25.
//  Copyright © 2025 CocoaHeads Albania. All rights reserved.
//

import SwiftUI

struct EventTypeView: View {
    
    var metadata: EventData?
    
    var body: some View {
        if let eventType = metadata?.eventType {
            HStack(spacing: 4) {
                Text(eventType.rawValue.localizedCapitalized)
                Image(systemName: eventType.icon)
            }
            .font(.body)
            .fontWeight(.medium)
            .lineLimit(1)
            .padding(.trailing, 6)
        } else {
            EmptyView()
        }
    }
}

#Preview {
    EventTypeView()
}
