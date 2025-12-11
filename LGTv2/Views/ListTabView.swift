//
//  ListTabView.swift
//  LGTv2
//
//  Created by Joseph Scholtz on 7/18/24.
//

import SwiftUI


struct ListTabView: View {
    
    @State var showSheet = false
    @Environment(ListTabViewModel.self) var listTabViewModel
    
    var body: some View {
        
            VStack {
                if listTabViewModel.eventsByDate.count == 0 {
                    noEventsFound
                }
                else {
                    eventList
                }
            }
            .onAppear() {
                listTabViewModel.sortEventsByDate()
            }
            .sheet(isPresented: $showSheet) {
                if let sheetEvent = listTabViewModel.selectedEvent {
                    EventDetailView(event: sheetEvent)
                        .presentationDetents([.medium, .large])
                }
            }
    }
}
    

// MARK: COMPONENTS
extension ListTabView {
    
    var noEventsFound: some View {
        VStack {
            Text("")
            Text("")
            Text("No events found")
            Spacer()
        }
    }
    
    var eventList: some View {
        // Group events by day and sort days
        let groupedByDay = Dictionary(grouping: listTabViewModel.eventsByDate) { event in
            Calendar.current.startOfDay(for: event.endDate.dateValue())
        }
        
        let sortedDays = groupedByDay.keys.sorted()

        return List {
            ForEach(sortedDays, id: \.self) { day in
                Section(header: Text(day.formatted(.dateTime.weekday(.wide).month(.abbreviated).day())).foregroundStyle(Color.primary).italic().font(.title2).fontWeight(.bold)) {
                    // sort events within a day by start time
                    let events = (groupedByDay[day] ?? []).sorted { lhs, rhs in
                        lhs.startDate.dateValue() < rhs.startDate.dateValue()
                    }
                    ForEach(events) { event in
                        ListCard(event: event)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
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
