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
    @State var calendarDisplayed = false
    @State var date = Date()
    @State private var position = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 42.567, longitude: -88.50189), span: MKCoordinateSpan(latitudeDelta: 0.18, longitudeDelta: 0.18)))
    
    
    var body: some View {
        
        @Bindable var eventModel = eventModel
        
        NavigationStack{
            ZStack {
                mapSection
                VStack (spacing:0) {
                    WxView()
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
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("TopLeading")
                }
                
                ToolbarItem(placement: .principal) {
                    dateSelector
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Text("Trailing")
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            }
        
    }
}

// MARK:COMPONENTS
extension MapTabView {
    
    var mapSection: some View {
        Map(position: $position) {
            ForEach(eventModel.events) { event in
                Annotation(event.name, coordinate: CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude)) {
                    Image(systemName: "mappin.and.ellipse")
                }
            }
            }
    }
    
    var dateSelector: some View {
        HStack {
            Text(date, format: .dateTime.month().day())
                .font(.title2)
                .overlay{
                    DatePicker(
                        "Select Date",
                        selection: $date,
                        in: Date()...,
                        displayedComponents: [.date]
                    )
                    .blendMode(.destinationOver)
                    .labelsHidden()
                    .id(calendarId)
                    .onChange(of: date) {
                        calendarId += 1
                    }
                }
                
            Image(systemName: "arrowtriangle.down.fill")
                .font(.caption)
                .rotationEffect(calendarDisplayed ? .degrees(-180) : .degrees(0))
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
