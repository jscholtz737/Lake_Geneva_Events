//
//  SearchTabViewModel.swift
//  LGTv2
//
//  Created by Joseph Scholtz on 12/8/25.
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseFirestore

@Observable class SearchTabViewModel {
    
    var upcomingEvents: [Event] = []
    var selectedEvent: Event?
    
    func getUpcomingEvents() {
        Task {
            let now = Date()
            upcomingEvents = await DataService.shared.events
                .filter { $0.startDate.dateValue() >= now }
                .sorted { $0.startDate.dateValue() < $1.startDate.dateValue() }
        }
    }
}
