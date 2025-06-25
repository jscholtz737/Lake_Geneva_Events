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
            
            LinearGradient(
                colors: [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)),Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))],
                startPoint: .top,
                endPoint: .bottom)
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

// MARK:COMPONENTS
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

#Preview {
    
    //var body: some View {
        
        ZStack {
            
            LinearGradient(colors: [Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)),Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))], startPoint: .top, endPoint: .bottom)
            
//            RadialGradient(
//                gradient: Gradient(colors: [Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)),Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))]),
//                center: .topTrailing,
//                startRadius: 10,
//                endRadius: 300)
//            .ignoresSafeArea()
        }
    
}


