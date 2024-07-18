//
//  ListView.swift
//  LGTv2
//
//  Created by Joseph Scholtz on 7/18/24.
//

import SwiftUI

struct ListView: View {
    
    @Environment(EventModel.self) var eventModel
    @State var selectedEvent: Event?
    
    var body: some View {
       
        List {
            ForEach(eventModel.events) {event in
    
                    HStack{
                        Image(event.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 75.0, height: 75.0)
                            .clipped()
                        VStack (alignment: .leading){
                            Text(event.name)
                            Text(event.location)
                        }
                        Spacer()
                        Text(event.time)
                    }
                    .onTapGesture {
                        selectedEvent = event
                    }
                }
            }
        .listStyle(.plain)
        .sheet(item: $selectedEvent) { event in
            EventDetailView(event: event)
        }
        }
    }


#Preview {
    ListView()
        .environment(EventModel())
}
