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
            eventsByDate = await DataService.shared.events
                .filter { $0.startDate.dateValue() >= now }
                .sorted { $0.startDate.dateValue() < $1.startDate.dateValue() }
        }
    }
}
