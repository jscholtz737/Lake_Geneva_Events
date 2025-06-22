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
    
    @State var eventModel:EventModel = EventModel()
    @State var crowdModel:CrowdModel = CrowdModel()
    @State private var calendarId: Int = 0
    @State var selectedTab = 0
    @State var date = Date()
    
    
    var body: some View {
        
        ZStack {
            
            Color.blue.opacity(0.1)
                .ignoresSafeArea()
            
            VStack (spacing:0) {
                title
                dateSelector
                WxView(date:date)
                mapListPicker
                if selectedTab == 1 {
                    ListView()
                }
                else {
                    MapView()
                }
            }
            .onAppear {
                eventModel.getEvents(date: date)
                crowdModel.getCrowds(date: date)
            }
            .sheet(item: $eventModel.selectedEvent) { item in
                EventDetailView()
            }
            .onChange(of: date) {
                eventModel.getEvents(date: date)
                crowdModel.getCrowds(date: date)
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                date = Date()
            }
            }
        .environment(eventModel)
        .environment(crowdModel)
        }
    }

//MARK:VIEWS
extension ContentView {
    
    var title: some View {
        VStack (spacing:0) {
            Text("")
            Text("Lake Geneva Events")
                .font(.largeTitle)
                .italic()
                .bold()
        }
    }
    
    var dateSelector: some View {
        DatePicker(
            "Selected Date",
            selection: $date,
            in: Date()...,
            displayedComponents: [.date]
        )
        .padding([.top, .bottom])
        .labelsHidden()
        .id(calendarId)
        .onChange(of: date) {
            calendarId += 1
        }
    }
    
    var mapListPicker: some View {
        Picker("", selection: $selectedTab) {
            Text("Map")
                .tag(0)
            Text("List")
                .tag(1)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.top)
    }
}

#Preview{
    
  
    }

