//
//  EventData.swift
//  CocoaHeadsAlbania
//
//  Created by Bruno Frani on 9.7.25.
//



import AlarmKit

struct EventData: AlarmMetadata {
    var createdAt: Date
    var eventType: EventType
    
    init(eventType: EventType, createdAt: Date) {
        self.createdAt = createdAt
        self.eventType = eventType
    }
    
    enum EventType: String, Codable, CaseIterable {
        case meetup
        case workshop
        case coffee
        case watchParty
        
        var icon: String {
            switch self {
            case .meetup: "person.3"
            case .workshop: "book.closed"
            case .coffee: "coffee"
            case .watchParty: "movie"
            }
        }
    }
}

