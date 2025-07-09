//
//  EventsAlarmsList.swift
//  CocoaHeadsAlbania
//
//  Created by Bruno Frani on 10.7.25.
//

import SwiftUI
import AlarmKit

struct EventsAlarmsList: View {
    
    var viewModel: EventsViewModel
    
    var body: some View {
        List {
            ForEach(Array(viewModel.alarmsMap.values), id: \.0.id) { (alarm, label) in
                EventAlarmCell(alarm: alarm, label: label)
            }
        }
    }
}

#Preview {
    EventsAlarmsList(viewModel: EventsViewModel())
}
