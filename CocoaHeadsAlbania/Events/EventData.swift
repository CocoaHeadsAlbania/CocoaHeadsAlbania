//
//  EventData.swift
//  CocoaHeadsAlbania
//
//  Created by Bruno Frani on 9.7.25.
//



import AlarmKit

struct EventData {
    let createdAt: Date
    let eventType: EventType?
    
    init(eventType: EventType? = .coffee, createdAt: Date = Date()) {
        self.createdAt = createdAt
        self.eventType = eventType
    }
    
    enum EventType: String, Codable {
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

