//
//  SearchViewTab.swift
//  LGTv2
//
//  Created by Joseph Scholtz on 12/7/25.
//

import SwiftUI
import FirebaseFirestore

struct SearchTabView: View {
    var body: some View {
        
        @Environment(SearchTabViewModel.self) var searchTabViewModel
        let blankEvent = Event(id: "", name: "", location: "", locationDetails: "", latitude: 0.0, longitude: 0.0, description: "", link: "", time: "", imageName: "", startDate: Timestamp(date: Date()), endDate: Timestamp(date: Date()), recurring: "")
        @State var searchText: String = ""
        @State var showSheet = false
        
        VStack {
            ForEach(searchTabViewModel.upcomingEvents) { event in
                ListCard(event: event)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color(.systemGray6))
                    )
                    .listRowBackground(Color.clear)
                    .onTapGesture {
                        searchTabViewModel.selectedEvent = event
                        showSheet.toggle()
                    }
            }
            .searchable(text: $searchText, placement: .automatic, prompt: "Search for an event")
        }
        .onAppear() {
            searchTabViewModel.getUpcomingEvents()
        }
        .sheet(isPresented: $showSheet) {
            EventDetailView(event: searchTabViewModel.selectedEvent ?? blankEvent)
                .presentationDetents([.medium, .large])
        }
    }
}

#Preview {
    SearchTabView()
        .environment(SearchTabViewModel())
}
