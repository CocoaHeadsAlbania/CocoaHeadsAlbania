//
//  PauseIntent.swift
//  CocoaHeadsAlbania
//
//  Created by Bruno Frani on 12.7.25.
//  Copyright © 2025 CocoaHeads Albania. All rights reserved.
//

import AlarmKit
import AppIntents

struct PauseIntent: LiveActivityIntent {
    func perform() throws -> some IntentResult {
        try AlarmManager.shared.pause(id: UUID(uuidString: alarmID)!)
        return .result()
    }
    
    static var title: LocalizedStringResource = "Pause"
    static var description = IntentDescription("Pause a countdown")
    
    @Parameter(title: "alarmID")
    var alarmID: String
    
    init(alarmID: String) {
        self.alarmID = alarmID
    }
    
    init() {
        self.alarmID = ""
    }
}
