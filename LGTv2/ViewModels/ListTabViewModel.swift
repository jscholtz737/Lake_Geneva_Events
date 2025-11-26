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
   
    
    init() {
        sortEventsByDate()
    }
    
    func sortEventsByDate() {
        eventsByDate = DataService.shared.events.sorted(by: { $0.startDate.dateValue() < $1.startDate.dateValue() })
    }
}
