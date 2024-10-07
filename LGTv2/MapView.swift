//
//  MapView.swift
//  LGTv2
//
//  Created by Joseph Scholtz on 6/28/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @Environment(EventModel.self) var eventModel
    @State var selectedEventId: String?
    
    @State private var position = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 42.567, longitude: -88.50189), span: MKCoordinateSpan(latitudeDelta: 0.18, longitudeDelta: 0.18)))
    
    var body: some View {
        Map(position: $position, selection: $selectedEventId)
        {
            ForEach (eventModel.events) {event in
                Marker(event.name, coordinate: CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude))
                    .tag(event.id)
            }
        }
        .onChange(of: selectedEventId) { oldValue, newValue in
            let event = eventModel.events.first { event in
                event.id == selectedEventId
            }
            if event != nil {
                eventModel.selectedEvent = event
            }
        }
        HStack {
            Button(action: {
                position = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 42.567, longitude: -88.50189), span: MKCoordinateSpan(latitudeDelta: 0.17, longitudeDelta: 0.17)))            }, label: {
                Text("Reset Map")
            })
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            position = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 42.567, longitude: -88.50189), span: MKCoordinateSpan(latitudeDelta: 0.17, longitudeDelta: 0.17))) 
        }
        Spacer()
    }
}
    

#Preview {
    MapView()
}
