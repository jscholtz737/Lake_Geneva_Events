//
//  SearchViewTab.swift
//  LGTv2
//
//  Created by Joseph Scholtz on 12/7/25.
//

import SwiftUI


struct SearchTabView: View {
    
    @Environment(SearchTabViewModel.self) var searchTabViewModel
    @State var showSheet = false
    @State private var debounceTimer: Timer?
    
    var body: some View {
        
        @Bindable var searchTabViewModel = searchTabViewModel
        
        NavigationStack {
            ScrollView {
                ForEach(searchTabViewModel.searchResults) { event in
                    ListCard(event: event)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                        .onTapGesture {
                            searchTabViewModel.selectedEvent = event
                            showSheet.toggle()
                        }
                }
            }
            .padding()
        }
        .onAppear() {
            searchTabViewModel.getUpcomingEvents()
        }
        .searchable(text: $searchTabViewModel.searchText, placement: .toolbar, prompt: "Search for an event")
        .sheet(isPresented: $showSheet) {
            if let sheetEvent = searchTabViewModel.selectedEvent {
                EventDetailView(event: sheetEvent)
                    .presentationDetents([.medium, .large])
            }
        }
    }
}

#Preview {
    
    SearchTabView()
        .environment(SearchTabViewModel())
}
