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


@Observable final class SearchTabViewModel {
    
    var upcomingEvents: [Event] = []
    var searchResults: [Event] = []
    var selectedEvent: Event?
    var searchText: String = "" {
        didSet { scheduleDebouncedSearch() }
    }
    private var searchTask: Task<Void, Never>?

    private func scheduleDebouncedSearch() {
        searchTask?.cancel()
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        searchTask = Task { [weak self] in
            // 400ms debounce
            try? await Task.sleep(nanoseconds: 400_000_000)
            guard let self, !Task.isCancelled else { return }
            if query.isEmpty {
                self.searchResults = []
            } else {
                self.searchEvents(searchText: query)
            }
        }
    }
    
    func getUpcomingEvents() {
        Task {
            let now = Date()
            upcomingEvents = await DataService.shared.events
                .filter { $0.startDate.dateValue() >= now }
                .sorted { $0.startDate.dateValue() < $1.startDate.dateValue() }
        }
    }
    
    func searchEvents(searchText: String) {
        let search = searchText.lowercased()
        searchResults = upcomingEvents.filter { event in
            let nameContains = event.name.lowercased().contains(search)
            let descriptionContains = event.description.lowercased().contains(search)
            return nameContains || descriptionContains
        }
    }
}
