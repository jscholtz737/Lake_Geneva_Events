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
    
    var body: some View {
        Map() {
            
            ForEach (eventModel.events) {event in
                Marker(event.name, coordinate: CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude))
            }
        }
    }
}

#Preview {
    MapView()
}
