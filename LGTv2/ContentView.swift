//
//  ContentView.swift
//  LGTv2
//
//  Created by Joseph Scholtz on 6/22/24.
//

import SwiftUI
import Foundation
import MapKit

struct ContentView: View {
    
    @Environment(EventModel.self) var eventModel
    @State var selectedTab = 0
    
    
    var body: some View {
        
        @Bindable var eventModel = eventModel
        
        VStack {
            Text("Lake Geneva Today")
                .font(.largeTitle)
                .italic()
                .bold()
            
            DatePicker(
                    "Selected Date",
                    selection: $eventModel.date,
                    in: Date()...,
                    displayedComponents: [.date]
                )
            .labelsHidden()
            
            WxView()
            
            Picker("", selection: $selectedTab) {
                Text("Map")
                    .tag(0)
                Text("List")
                    .tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            
            
            if selectedTab == 1 {
                ListView()
            }
            else {
                MapView()
            }
        }
        .onAppear {
            eventModel.getEvents()
                
        }
        .sheet(item: $eventModel.selectedEvent) { item in
            EventDetailView()
        } 
        .onChange(of: eventModel.date) {
            eventModel.getEvents()
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
