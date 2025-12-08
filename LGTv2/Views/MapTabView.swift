//
//  MapTabView.swift
//  LGTv2
//
//  Created by Joseph Scholtz on 6/25/25.
//

import SwiftUI
import Foundation
import MapKit
import FirebaseFirestore

struct MapTabView: View {
    
    
    @Environment(MapTabViewModel.self) var mapTabViewModel
    @State private var calendarId: Int = 0
    @State var calendarDisplayed = false
    @State var date = Date()
    @State private var position = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 42.567, longitude: -88.50189), span: MKCoordinateSpan(latitudeDelta: 0.18, longitudeDelta: 0.18)))
    
    //believe these are old vars not needed anymore...
    //@State var selectedEventId: String?
    //@State var showSheet = false
    //@State private var dropped = false
    //var blankEvent = Event(id: "", name: "", location: "", locationDetails: "", latitude: 0.0, longitude: 0.0, description: "", link: "", time: "", imageName: "", startDate: Timestamp(date: Date()), endDate: Timestamp(date: Date()), recurring: "daily")
    
    //id on the card tab view to increase scale effect on corresponding map pin annotation
    @State private var selectedCardEventId: String? = nil
    
    var body: some View {
        
            ZStack {
                Group {
                    if selectedCardEventId != nil || mapTabViewModel.filteredEvents.isEmpty {
                        mapWithEvents
                    }
                }
                
                VStack {
                    header
                    Spacer()
                    
                    TabView(selection: $selectedCardEventId) {
                        ForEach(mapTabViewModel.filteredEvents) { event in
                            
                            MapCard(cardEvent: event)
                                .padding(.horizontal, 16)
                                .shadow(color: Color.black.opacity(0.3), radius: 20)
                                .tag(Optional(event.id))
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .automatic))
                    .frame(maxHeight: 220)
                }
            }
            .onAppear() {
                mapTabViewModel.getEvents()
                mapTabViewModel.getCrowds(date: date)
            }

            .onChange(of: date) {
                mapTabViewModel.filterForSelectedDate(date: date)
                mapTabViewModel.getCrowds(date: date)
            }
            .onChange(of: mapTabViewModel.filteredEvents) {
                if selectedCardEventId == nil, let first = mapTabViewModel.filteredEvents.first {
                    selectedCardEventId = first.id
                } else if let current = selectedCardEventId, !mapTabViewModel.filteredEvents.contains(where: { $0.id == current }) {
                    // Current selection no longer exists; reset to first if available
                    selectedCardEventId = mapTabViewModel.filteredEvents.first?.id
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                date = Date()
            }
    }
}

// MARK:COMPONENTS
extension MapTabView {
    
    var mapWithEvents: some View {
        Map(position: $position) {
            ForEach(mapTabViewModel.filteredEvents) { event in
                Annotation("", coordinate: CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude)) {
                    Image(systemName: "mappin")
                        .font(.title)
                        .bold()
                        .foregroundStyle(.purple)
                        .scaleEffect(selectedCardEventId == event.id ? 1.6 : 1.0)
                        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: selectedCardEventId)
                        .symbolEffect(.bounce, value: selectedCardEventId == event.id)
                }
            }
        }
    }
    
    var header: some View {
        HStack {
            WxView()
            Spacer()
            dateSelector
            Spacer()
            CrowdView()
        }
        .offset(y: -12)
        .padding([.leading, .trailing])
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: .warmBlue.opacity(0.9), location: 0.0),
                    .init(color: .warmBlue.opacity(0.7), location: 0.6),
                    .init(color: .warmBlue.opacity(0.35), location: 0.8),
                    .init(color: .warmBlue.opacity(0.0), location: 1.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
    
    var dateSelector: some View {
        HStack {
            VStack {
                Text(date, format: .dateTime.weekday(.wide))
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(date, format: .dateTime.month().day())
            }
           
            Image(systemName: "chevron.down")
                .font(.subheadline)
                .fontWeight(.heavy)
                .rotationEffect(calendarDisplayed ? .degrees(-180) : .degrees(0))
                .animation(.easeInOut, value: calendarDisplayed)
        }
        .foregroundStyle(Color.white)
        .padding([.leading, .trailing])
        .padding(.bottom,2)
        .onTapGesture {
            calendarDisplayed.toggle()
        }
        .sheet(isPresented: $calendarDisplayed) {
            DatePicker(
                "Select Date",
                selection: $date,
                in: Calendar.current.startOfDay(for: Date())...,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .labelsHidden()
            .id(calendarId)
            .onChange(of: date) {
                calendarId += 1
                calendarDisplayed = false
            }
            .presentationDetents([.medium, .large]) // enables half-screen and full-screen
            .presentationDragIndicator(.visible)
            .padding()
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
        .environment(MapTabViewModel())
    
}

