//
//  ListView.swift
//  LGTv2
//
//  Created by Joseph Scholtz on 7/18/24.
//

import SwiftUI

struct ListView: View {
    
    @Environment(EventModel.self) var eventModel
   
    
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
                    eventModel.selectedEvent = event
                }
            }
        }
        .listStyle(.plain)
        
    }
    }




#Preview {
    ListView()
        .environment(EventModel())
}
