//
//  LockScreenView.swift
//  CocoaHeadsAlbania
//
//  Created by Bruno Frani on 12.7.25.
//  Copyright © 2025 CocoaHeads Albania. All rights reserved.
//

import SwiftUI
import AlarmKit

struct LockScreenView: View {
    
    var attributes: AlarmAttributes<EventData>
    var state: AlarmPresentationState
    
    var body: some View {
       
        VStack {
            HStack(alignment: .top) {
                AlarmTitleView(attributes: attributes, state: state)
                Spacer()
                EventTypeView(metadata: attributes.metadata)
            }
            
            BottomView(attributes: attributes, state: state)
        }
        .padding(.all, 12)
        
    }
}

#Preview {
//    LockScreenView()
}

