//
//  ListTabView.swift
//  LGTv2
//
//  Created by Joseph Scholtz on 7/18/24.
//

import SwiftUI

struct ListTabView: View {
    
    @Environment(MapTabViewModel.self) var eventModel
    
    var body: some View {
        
        @Bindable var eventModel = eventModel
        
        VStack{
            if eventModel.events.count == 0 {
                noEventsScheduled
            }
            else {
                eventList
            }
        }
//        .onAppear {
//            eventModel.getAllEvents()
//        }
        .sheet(item: $eventModel.selectedEvent) { item in
            EventDetailView()
        }
    }
}

// MARK: COMPONENTS
extension ListTabView {
    
    var noEventsScheduled: some View {
        VStack {
            Text("")
            Text("")
            Text("No events scheduled")
            Spacer()
        }
    }
    
    var eventList: some View {
        List {
            ForEach(eventModel.events) {event in
                
                HStack{
                    Image(event.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 75.0, height: 75.0)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    VStack (alignment: .leading){
                        Text(event.name)
                            .bold()
                        Text(event.location)
                            .italic()
                            .font(.subheadline)
                    }
                    Spacer()
                    Text(event.time)
                        .font(.subheadline)
                }
                .alignmentGuide(.listRowSeparatorLeading) {d in d[.leading]}
                .onTapGesture {
                    eventModel.selectedEvent = event
                }
            }
        }
        .listStyle(.plain)
    }
}


#Preview {
    
    ListTabView()
        .environment(MapTabViewModel())
}
