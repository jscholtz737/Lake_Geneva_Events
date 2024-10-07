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
