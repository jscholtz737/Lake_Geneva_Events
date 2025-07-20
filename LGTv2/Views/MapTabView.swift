//
//  MapTabView.swift
//  LGTv2
//
//  Created by Joseph Scholtz on 6/25/25.
//

import SwiftUI
import Foundation
import MapKit

struct MapTabView: View {
    
    @Environment(EventModel.self) var eventModel
    @Environment(CrowdModel.self) var crowdModel
    @State private var calendarId: Int = 0
    @State var selectedView = 0
    @State var date = Date()
    
    @State var selectedEventId: String?
    @State private var position = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 42.567, longitude: -88.50189), span: MKCoordinateSpan(latitudeDelta: 0.18, longitudeDelta: 0.18)))
    
    
    var body: some View {
        
        @Bindable var eventModel = eventModel
        
        ZStack {
            LinearGradient(
                colors: [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)),Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))],
                startPoint: .top,
                endPoint: .bottom)
            .ignoresSafeArea()
            
            VStack (spacing:0) {
                title
                dateSelector
                WxView()
                map
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
    }
}

// MARK:COMPONENTS
extension MapTabView {
    
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
    
    var map: some View {
        Map(position: $position, selection: $selectedEventId)
        {
            ForEach (eventModel.events) {event in
                Marker(event.name, coordinate: CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude))
                    .tag(event.id)
            }
        }
        .toolbarBackground(.hidden)
        .onChange(of: selectedEventId) { oldValue, newValue in
            let event = eventModel.events.first { event in
                event.id == selectedEventId
            }
            if event != nil {
                eventModel.selectedEvent = event
            }
        }
    }
    
    //reset button to move map back to center after moving or zooming.  from ver1,not currently used in ver2.
    var resetMapButton: some View {
        Button(action: {
            position = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 42.567, longitude: -88.50189), span: MKCoordinateSpan(latitudeDelta: 0.17, longitudeDelta: 0.17)))            }, label: {
                Text("Reset Map")
            })
    }
}

#Preview {
    
    MapTabView()
        .environment(EventModel())
        .environment(CrowdModel())
    
}
