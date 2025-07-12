//
//  EventsView.swift
//  CocoaHeadsAlbania
//
//  Created by Bruno Frani on 9.7.25.
//

import SwiftUI
import AlarmKit

struct EventsView: View {
    
    @State private var viewModel = EventsViewModel()
    
    var body: some View {
        
        NavigationStack {
            
            content
                .navigationTitle("Alarms")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    Button {
                        viewModel.scheduleCountdownAlertExample()
                    } label: {
                        Image(systemName: "plus")
                    }
                    
                }
        }
        
        .environment(viewModel)
        .onAppear {
            viewModel.fetchAlarms()
        }
        .tint(.accentColor)
    }
    
    @ViewBuilder var content: some View {
        if viewModel.hasUpcomingAlerts {
            List {
                ForEach(Array(viewModel.alarmsMap.values), id: \.0.id) { (alarm, label) in
                    EventAlarmCell(alarm: alarm, label: label)
                }
                .onDelete { indexSet in
                    indexSet.forEach { idx in
                        viewModel.unscheduleAlarm(with: Array(viewModel.alarmsMap.values)[idx].0.id)
                    }
                }
            }
        } else {
            ContentUnavailableView("No Alarms", systemImage: "clock.badge.exclamationmark", description: Text("Add a new alarm by tapping + button."))
        }
    }
}

#Preview {
    EventsView()
}
