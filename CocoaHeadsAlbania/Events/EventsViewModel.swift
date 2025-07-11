//
//  EventsViewModel.swift
//  CocoaHeadsAlbania
//
//  Created by Bruno Frani on 9.7.25.
//

import Foundation
import Combine
import AlarmKit
import SwiftUI


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
    
    // Schedules an alarm with an alert only.
    func scheduleAlertOnlyExample() {
        let alertContent = AlarmPresentation.Alert(title: "Wake Up", stopButton: .stopButton)
        
        let attributes = AlarmAttributes<EventData>(presentation: AlarmPresentation(alert: alertContent),
                                                      tintColor: Color.accentColor)
        
        let alarmConfiguration = AlarmConfiguration(schedule: .oneMinFromNow, attributes: attributes)
        
        scheduleAlarm(id: UUID(), label: "Wake Up", alarmConfiguration: alarmConfiguration)
    }
    
    //------------------------------------------------------------
    
    func scheduleAlarm(id: UUID, label: LocalizedStringResource, alarmConfiguration: AlarmConfiguration<EventData>) {
        Task {
            do {
                guard await requestAuthorization() else {
                    print("Not authorized to schedule alarms.")
                    return
                }
                let alarm = try await alarmManager.schedule(id: id, configuration: alarmConfiguration)
                await MainActor.run {
                    alarmsMap[id] = (alarm, label)
                }
            } catch {
                print("Error encountered when scheduling alarm: \(error)")
            }
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

//func scheduleAlarm () {
//    
//    let countDownDuration = Alarm.CountdownDuration(preAlert: (10 * 60), postAlert: (5 * 60))
//    
//    let keynoteDateComponents = DateComponents(
//        calendar: .current,
//        year: 2025,
//        month: 6,
//        day: 9,
//        hour: 9,
//        minute:41)
//    
//    let keynoteDate = Calendar.current.date(from: keynoteDateComponents)!
//    
//    let scheduleFixed = Alarm.Schedule.fixed(keynoteDate)
//    
//    
//  
//    let stopButton = AlarmButton.stopButton
//    let repeatButton = AlarmButton.repeatButton
//    
//    let alertPresentation = AlarmPresentation.Alert(
//        title: "Meetup starting soon!",
//        stopButton: stopButton,
//        secondaryButton: repeatButton,
//        secondaryButtonBehavior: .countdown)
//    
//    
//    let attributes = AlarmAttributes<EventData>(presentation: AlarmPresentation(alert: alertPresentation) , tintColor: Color.green)
//    
//    let alarmConfiguration = AlarmConfiguration(countdownDuration: countDownDuration, attributes: attributes)
//}
