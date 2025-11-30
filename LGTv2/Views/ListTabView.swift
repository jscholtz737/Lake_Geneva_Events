//
//  ListTabView.swift
//  LGTv2
//
//  Created by Joseph Scholtz on 7/18/24.
//

import SwiftUI
import FirebaseFirestore

struct ListTabView: View {
    
    var date = Date()
    @State var showSheet = false
    var blankEvent = Event(id: "", name: "", location: "", locationDetails: "", latitude: 0.0, longitude: 0.0, description: "", link: "", time: "", imageName: "", startDate: Timestamp(date: Date()), endDate: Timestamp(date: Date()), recurring: "daily")
    @Environment(ListTabViewModel.self) var listTabViewModel
    
    var body: some View {
        
            VStack {
                if listTabViewModel.eventsByDate.count == 0 {
                    noEventsScheduled
                }
                else {
                    eventList
                }
            }
            .onAppear() {
                listTabViewModel.sortEventsByDate()
            }
            .sheet(isPresented: $showSheet) {
                EventDetailView(event: listTabViewModel.selectedEvent ?? blankEvent)
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
                            showSheet.toggle()
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
        .environment(ListTabViewModel())
}
