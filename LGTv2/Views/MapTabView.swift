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
    
    
    @Environment(MapTabViewModel.self) var mapTabViewModel
    @Environment(CrowdModel.self) var crowdModel
    @State private var calendarId: Int = 0
    @State var calendarDisplayed = false
    @State var date = Date()
    @State private var position = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 42.567, longitude: -88.50189), span: MKCoordinateSpan(latitudeDelta: 0.18, longitudeDelta: 0.18)))
    @State var selectedEventId: String?
    
    
    var body: some View {
        
        @Bindable var mapTabViewModel = mapTabViewModel
        
        NavigationStack{
            ZStack {
                mapWithEvents
            }
            .onAppear() {
                mapTabViewModel.filterForSelectedDate(date: date)
            }
            .toolbar {
                ToolbarItem(placement:.topBarLeading) {
                    WxView()
                }
                
                ToolbarItem(placement: .principal) {
                    dateSelector
                        .border(.orange, width: 2) //border for testing
                }
                
                
                ToolbarItem(placement: .topBarTrailing) {
                    CrowdView()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: selectedEventId) { oldValue, newValue in
                setSelectedEvent()
            }
            .sheet(item: $mapTabViewModel.selectedEvent) { item in
                EventDetailView()
            }
            .onChange(of: date) {
                mapTabViewModel.filterForSelectedDate(date: date)
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
    
    var mapWithEvents: some View {
        Map(position: $position, selection: $selectedEventId) {
            ForEach(mapTabViewModel.filteredEvents) { event in
                Annotation(event.name, coordinate: CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude)) {
                    Image(systemName: "mappin.and.ellipse")
                }
            }
            }
    }
    
    var dateSelector: some View {
        VStack {
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
            Text(date, format: .dateTime.weekday(.wide))
        }
    }
    
    //reset button to move map back to center after moving or zooming.  from ver1,not currently used in ver2.
    var resetMapButton: some View {
        Button(action: {
            position = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 42.567, longitude: -88.50189), span: MKCoordinateSpan(latitudeDelta: 0.17, longitudeDelta: 0.17)))            }, label: {
                Text("Reset Map")
            })
    }
    
    func setSelectedEvent() {
        let event = mapTabViewModel.events.first { event in
            event.id == selectedEventId
        }
        if event != nil {
            mapTabViewModel.selectedEvent = event
        }
    }
}

#Preview {
    
    MapTabView()
        .environment(MapTabViewModel())
        .environment(CrowdModel())
    
}
