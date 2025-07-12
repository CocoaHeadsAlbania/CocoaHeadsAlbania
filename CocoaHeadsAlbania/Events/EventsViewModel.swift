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
    
    func scheduleAlarm() {
        
        let randomEvent = generateRandomEvent()
        
        let title = LocalizedStringResource(stringLiteral: randomEvent.eventType.rawValue)
        
        let secondaryButtonBehaviour = AlarmPresentation.Alert.SecondaryButtonBehavior.countdown
        
        let alertContent = AlarmPresentation.Alert(title: title,
                                                   stopButton: .stopButton,
                                                   secondaryButton: .repeatButton,
                                                   secondaryButtonBehavior: secondaryButtonBehaviour)

        
        let alarmPresentation = AlarmPresentation(alert: alertContent)
        
        let attributes = AlarmAttributes(presentation: alarmPresentation, metadata: randomEvent, tintColor: .red)
        
        let id = UUID()
        
        let alarmConfiguration = AlarmConfiguration(
            schedule: .oneMinFromNow,
            attributes: attributes,
            stopIntent: StopIntent(alarmID: id.uuidString),
            secondaryIntent: RepeatIntent(alarmID: id.uuidString))
        
        scheduleAlarm(
            id: id,
            label: title,
            alarmConfiguration: alarmConfiguration)
        
    }
    
    //------------------------------------------------------------
    
    // Schedules an alarm with countdown button.
    func scheduleCountdownAlertExample() {
        
        let randomEvent = generateRandomEvent()
        
        let title = LocalizedStringResource(stringLiteral: randomEvent.eventType.rawValue)
        
        let alertContent = AlarmPresentation.Alert(title: title,
                                                   stopButton: .stopButton,
                                                   secondaryButton: .repeatButton,
                                                   secondaryButtonBehavior: .countdown)
        
        let countdownContent = AlarmPresentation.Countdown(title: "Starting Soon", pauseButton: .pauseButton)
        
        let pausedContent = AlarmPresentation.Paused(title: "Paused", resumeButton: .resumeButton)
        
        let attributes = AlarmAttributes(presentation: AlarmPresentation(alert: alertContent, countdown: countdownContent, paused: pausedContent),
                                         metadata: randomEvent,
                                         tintColor: Color.accentColor)
        
        let id = UUID()
        let alarmConfiguration = AlarmConfiguration(
            countdownDuration: .init(preAlert: 1 * 60, postAlert: 1 * 60),
            attributes: attributes,
            secondaryIntent: RepeatIntent(alarmID: id.uuidString))
        
        scheduleAlarm(
            id: UUID(),
            label: title,
            alarmConfiguration: alarmConfiguration)
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
    
    //------------------------------------------------------------
        
    
    func generateRandomEvent() -> EventData {
        
        let allTypes = EventData.EventType.allCases
    
        let randomEventType = allTypes.randomElement() ?? .coffee
        
        let event = EventData(eventType: randomEventType, createdAt: Date())
        
        return event
    }
}
