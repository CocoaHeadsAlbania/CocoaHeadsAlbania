//
//  Alarm+Schedule.swift
//  CocoaHeadsAlbania
//
//  Created by Bruno Frani on 11.7.25.
//

import AlarmKit

extension Alarm.Schedule {
    
    static var twoMinsFromNow: Self {
        let twoMinsFromNow = Date.now.addingTimeInterval(2 * 60)
        let time = Alarm.Schedule.Relative.Time(hour: Calendar.current.component(.hour, from: twoMinsFromNow),
                                                minute: Calendar.current.component(.minute, from: twoMinsFromNow))
        return .relative(.init(time: time))
    }
    
    //------------------------------------------------------------
    
    static var oneMinFromNow: Self {
        let oneMinFromNow = Date.now.addingTimeInterval(60)
        let time = Alarm.Schedule.Relative.Time(hour: Calendar.current.component(.hour, from: oneMinFromNow),
                                                minute: Calendar.current.component(.minute, from: oneMinFromNow))
        return .relative(.init(time: time))
    }
}
