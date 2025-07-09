//
//  EventsViewModel.swift
//  CocoaHeadsAlbania
//
//  Created by Bruno Frani on 9.7.25.
//

import Foundation
import Combine
import AlarmKit


@Observable class EventsViewModel {
    
    typealias AlarmConfiguration = AlarmManager.AlarmConfiguration
    typealias AlarmsMap = [UUID: (Alarm, LocalizedStringResource)]
    
    @ObservationIgnored private let alarmManager = AlarmManager.shared
    @MainActor var alarmsMap = AlarmsMap()
    
    @MainActor var hasUpcomingAlerts: Bool {
        !alarmsMap.isEmpty
    }
    
    //------------------------------------------------------------
    
    private func requestAuthorization() async -> Bool {
        switch alarmManager.authorizationState {
        case .notDetermined:
            do {
                let state = try await alarmManager.requestAuthorization()
                return state == .authorized
            } catch {
                print("Error occurred while requesting authorization: \(error)")
                return false
            }
        case .denied: return false
        case .authorized: return true
        @unknown default: return false
        }
    }
    
    //------------------------------------------------------------
    
    func fetchAlarms() {
        do {
            let remoteAlarms = try alarmManager.alarms
            updateAlarmState(with: remoteAlarms)
        } catch {
            print("Error fetching alarms: \(error)")
        }
    }
    
    //------------------------------------------------------------
    
    func unscheduleAlarm(with alarmID: UUID) {
        try? alarmManager.cancel(id: alarmID)
        Task { @MainActor in
            alarmsMap[alarmID] = nil
        }
    }
    
    //------------------------------------------------------------
    
    
    func scheduleAlertOnlyExample() {
        
        // follow these steps :
        // create attribures
        // create configuration
        // schedule alarm
        
        Task {
            guard await requestAuthorization() else {
                print("Not authorized to schedule alarms.")
                return
            }
            // create alarm
            
        }
    }
    
    
    //------------------------------------------------------------
    
    
    private func observeAlarms() {
        Task {
            for await incomingAlarms in alarmManager.alarmUpdates {
                updateAlarmState(with: incomingAlarms)
            }
        }
    }
    
    //------------------------------------------------------------
    
    private func updateAlarmState(with remoteAlarms: [Alarm]) {
        Task { @MainActor in
            
            // Update existing alarm states.
            remoteAlarms.forEach { updated in
                alarmsMap[updated.id, default: (updated, "Alarm (Old Session)")].0 = updated
            }
            
            let knownAlarmIDs = Set(alarmsMap.keys)
            let incomingAlarmIDs = Set(remoteAlarms.map(\.id))
            
            // Clean-up removed alarms.
            let removedAlarmIDs = Set(knownAlarmIDs.subtracting(incomingAlarmIDs))
            removedAlarmIDs.forEach {
                alarmsMap[$0] = nil
            }
        }
    }
    
    
}
