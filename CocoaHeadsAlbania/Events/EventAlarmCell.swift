//
//  EventAlarmCell.swift
//  CocoaHeadsAlbania
//
//  Created by Bruno Frani on 10.7.25.
//

import SwiftUI
import AlarmKit

struct EventAlarmCell: View {
    var alarm: Alarm
    var label: LocalizedStringResource
    
    var body: some View {
        
        HStack {
            if let alertingTime = alarm.alertingTime {
                Text(alertingTime, style: .time)
                    .font(.title)
                    .fontWeight(.medium)
            } else if let countdown = alarm.countdownDuration?.preAlert {
                Text(countdown.customFormatted())
                    .font(.title)
                    .fontWeight(.medium)
            }
            
        }
    }
}

//#Preview {
//    EventAlarmCell(alarm: Alarm(hour: 2, minute: 29), label: "Conference")
//}
