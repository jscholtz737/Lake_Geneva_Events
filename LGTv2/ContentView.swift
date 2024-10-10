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
    @State private var calendarId: Int = 0
    @State var selectedTab = 0
    
    
    var body: some View {
        
        @Bindable var eventModel = eventModel
        
        VStack {
            Text("")
            Text("Lake Geneva Events")
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
            .id(calendarId)
            .onChange(of: eventModel.date) {
              calendarId += 1
            }
            
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
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            eventModel.date = Date()
        }
        
    }
}

#Preview{
    
    @Previewable @State var selectedTab = 0
    
    @Previewable @State var date = Date()
    
    @Previewable @State var position = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 42.567, longitude: -88.50189), span: MKCoordinateSpan(latitudeDelta: 0.18, longitudeDelta: 0.18)))
    
    @Previewable var eventList = Event(id: "1", name: "one", location: "two", latitude: 0, longitude: 0, description: "stuff", time: "8am", imageName: "LakeGeneva", date: ["Oct 4"])
    
    VStack {
        Text("Lake Geneva Events")
            .font(.largeTitle)
            .italic()
            .bold()
        
        DatePicker(
            "Selected Date",
            selection: $date,
            in: Date()...,
            displayedComponents: [.date]
        )
        .labelsHidden()
        
        HStack{
            VStack (spacing: 0) {
                Text("Current Weather")
                    .italic()
                    .font(.subheadline)
                    .padding(.leading)
                    .padding(.top)
                Image("113")
                HStack {
                    let stringTemp = "55"
                    Text(stringTemp + "°")
                        .padding(.trailing)
                        .font(.subheadline)
                    let stringWind = "11"
                    Image(systemName: "wind")
                        .font(.system(size: 15))
                    Text(stringWind)
                        .font(.subheadline)
            }
        }
            Spacer()
            VStack (spacing: 0) {
                Text ("Expected Crowds")
                    .italic()
                    .font(.subheadline)
                    .padding(.trailing)
                    .padding(.top)
                Image(systemName: "person.fill")
                            .foregroundColor(.green)
                            .font(.system(size: 24))
                            .scaledToFit()
                            .frame(width: 48, height: 49)
                            .padding(.trailing)
                    Text("Low")
                        .font(.subheadline)
                        .padding(.trailing)
                }
            }
         
            }
        
        Picker("", selection: $selectedTab) {
            Text("Map")
                .tag(0)
            Text("List")
                .tag(1)
        }
        .pickerStyle(SegmentedPickerStyle())
        
        
        if selectedTab == 1 {
            List{
                HStack {
                    Text(eventList.name)
                    Text(eventList.description)
                }
            }
        }
        else {
            Map()
            HStack {
                Button(action: {
                    position = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 42.567, longitude: -88.50189), span: MKCoordinateSpan(latitudeDelta: 0.17, longitudeDelta: 0.17)))            }, label: {
                    Text("Reset Map")
                })
            }
        }
    }

