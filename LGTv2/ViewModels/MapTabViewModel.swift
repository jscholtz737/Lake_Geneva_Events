//
//  EventModel.swift
//  LGTv2
//
//  Created by Joseph Scholtz on 6/28/24.
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseFirestore


@Observable final class MapTabViewModel {
    
    var events: [Event] = []
    var filteredEvents: [Event] = []
    var selectedEvent: Event?
    
    init() {
        self.getEvents()
    }
    
    func getEvents() {
        Task {
            await DataService.shared.getFirebaseEvents()
            events = DataService.shared.events
        }
    }
    
    func filterForSelectedDate(date: Date) {
        filteredEvents = events.filter { event in
            let eventDate = event.startDate.dateValue() // Timestamp -> Date
            return Calendar.current.isDate(eventDate, inSameDayAs: date)
        }
    }


}

