//
//  ListTabViewModel.swift
//  LGTv2
//
//  Created by Joseph Scholtz on 11/19/25.
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseFirestore

@Observable class ListTabViewModel {
    
    var selectedEvent: Event?
    var eventsByDate: [Event] = []
    
    func sortEventsByDate() {
        Task {
            let now = Date()
            print(now)
            eventsByDate = await DataService.shared.events
                .filter { $0.endDate.dateValue() >= now }
                .sorted { $0.endDate.dateValue() < $1.endDate.dateValue() }
           for event in eventsByDate {
               print(event.endDate.dateValue())
            }
            
        }
    }
}
