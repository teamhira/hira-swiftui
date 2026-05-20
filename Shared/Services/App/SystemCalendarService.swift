//
//  SystemCalendarService.swift
//  Hira
//
//  Created by Ryuk on 24/04/26.
//

import Foundation
import EventKit

public final class SystemCalendarService {
    public static let shared = SystemCalendarService()
    private let eventStore = EKEventStore()
    
    private init() {}
    
    public func requestAccess() async -> Bool {
        if #available(iOS 17.0, *) {
            do {
                return try await eventStore.requestFullAccessToEvents()
            } catch {
                return false
            }
        } else {
            return await withCheckedContinuation { continuation in
                eventStore.requestAccess(to: .event) { granted, _ in
                    continuation.resume(returning: granted)
                }
            }
        }
    }
    
    public func addEvent(title: String, description: String, date: Date) async -> Result<Void, Error> {
        let hasAccess = await requestAccess()
        guard hasAccess else {
            return .failure(NSError(domain: "SystemCalendarService", code: 403, userInfo: [NSLocalizedDescriptionKey: "Calendar access denied"]))
        }
        
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.notes = description
        event.startDate = date
        event.endDate = date.addingTimeInterval(3600) // 1 hour duration
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        do {
            try eventStore.save(event, span: .thisEvent)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    public func checkEventExists(title: String, date: Date) async -> Bool {
        let hasAccess = await requestAccess()
        guard hasAccess else { return false }
        
        // Search for events on that day
        let calendars = eventStore.calendars(for: .event)
        let startDate = Calendar.current.startOfDay(for: date)
        let endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
        
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: calendars)
        let events = eventStore.events(matching: predicate)
        
        return events.contains { $0.title == title }
    }
}

