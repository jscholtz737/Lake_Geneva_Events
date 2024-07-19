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
    
    var body: some View {
        Map(selection: $selectedEventId) {
            
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
    }
}

#Preview {
    MapView()
}
