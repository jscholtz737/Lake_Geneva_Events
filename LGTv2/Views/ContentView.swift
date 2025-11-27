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

    @State var selectedTab = 0
  
    var body: some View {
        
            TabView(selection: $selectedTab) {
                Tab("Map", systemImage: "map.fill", value: 0) {
                    MapTabView()
                }
                Tab("All", systemImage: "calendar", value: 1) {
                    ListTabView()
                }
                Tab("Send", systemImage: "mail", value: 2) {
                    Text("Send event")
                }
            }
    }
}

#Preview {
    
    ContentView()
        .environment(MapTabViewModel())
        .environment(ListTabViewModel())
}

