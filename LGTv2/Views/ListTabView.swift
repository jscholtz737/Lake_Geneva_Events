//
//  ListTabView.swift
//  LGTv2
//
//  Created by Joseph Scholtz on 7/18/24.
//

import SwiftUI

struct ListTabView: View {
    
    var date = Date()
    @State private var listTabViewModel:ListTabViewModel = ListTabViewModel()
    @State var dateGroup: Date?
    
    var body: some View {
            VStack {
                if listTabViewModel.eventsByDate.count == 0 {
                    noEventsScheduled
                }
                else {
                    eventList
                }
            }
            .sheet(item: $listTabViewModel.selectedEvent) { item in
                EventDetailView(event: item)
                    .presentationDetents([.medium, .large]) 
            }
    }
}
    

// MARK: COMPONENTS
extension ListTabView {
    
    var noEventsScheduled: some View {
        VStack {
            Text("")
            Text("")
            Text("No events scheduled")
            Spacer()
        }
    }
    
    var eventList: some View {
        // Group events by day and sort days
        let groupedByDay = Dictionary(grouping: listTabViewModel.eventsByDate) { event in
            Calendar.current.startOfDay(for: event.startDate.dateValue())
        }
        let sortedDays = groupedByDay.keys.sorted()

        return List {
            ForEach(sortedDays, id: \.self) { day in
                Section(header: Text(day.formatted(.dateTime.weekday(.wide).month(.abbreviated).day()))) {
                    // Optionally sort events within a day by start time
                    let events = (groupedByDay[day] ?? []).sorted { lhs, rhs in
                        lhs.startDate.dateValue() < rhs.startDate.dateValue()
                    }
                    ForEach(events) { event in
                        ListCard(event: event)
                        .alignmentGuide(.listRowSeparatorLeading) { d in d[.leading] }
                        .onTapGesture {
                            listTabViewModel.selectedEvent = event
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
    }
}


#Preview {
    
    ListTabView()
        .environment(MapTabViewModel()) //MapTabViewModel runs the getFireBaseEvents function
}
