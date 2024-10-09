//
//  EventDetailView.swift
//  LGTv2
//
//  Created by Joseph Scholtz on 6/22/24.
//

import SwiftUI

struct EventDetailView: View {
    
    @Environment(EventModel.self) var eventModel
    
    var body: some View {
        ZStack{
            Image(eventModel.selectedEvent?.imageName ?? "")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
                .ignoresSafeArea()
                .opacity(0.2)
        
            VStack{
                Text(eventModel.selectedEvent?.name ?? "")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                    .multilineTextAlignment(.center)
                Spacer()
                Text(eventModel.selectedEvent?.description ?? "")
                Text(eventModel.selectedEvent?.location ?? "")
                Text(eventModel.selectedEvent?.time ?? "")
            }
            .padding(.leading)
            .padding(.trailing)
        }
    }
}

#Preview {
    ZStack{
        Image("LakeGeneva")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .clipped()
            .ignoresSafeArea()
            .opacity(0.2)
    
        VStack{
            Text("Electric Christmas Parade")
                .frame(width: 300)
                .font(.largeTitle)
                .bold()
                .padding()
                .multilineTextAlignment(.center)
            Spacer()
            Text("Join us for a joyful celebration of the season as this colorful, light-filled parade moves down Broad and Main Streets in Downtown Lake Geneva.Spectators of all ages will enjoy magical floats and more creative displays.")
            Text("Broad Street")
            Text("7pm")
            Spacer()
        }
        .padding(.leading)
        .padding(.trailing)
    }
}

