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
        VStack{
            Image(eventModel.selectedEvent?.imageName ?? "Generic")
                .resizable()
                .frame(height: 200)
                .aspectRatio(contentMode: .fit)
                .clipped()
                .ignoresSafeArea()
                .opacity(0.3)
            
            Text(eventModel.selectedEvent?.name ?? "")
                .font(.largeTitle)
                .bold()
                .padding()
                .multilineTextAlignment(.center)
        }
        VStack {
            HStack{
                Image(systemName: "location")
                    .padding([.leading, .trailing])
                    .foregroundColor(Color(.green))
                    .font(.system(size: 18))
                Text(eventModel.selectedEvent?.locationDetails ?? "")
                    .font(.callout)
                Spacer()
            }
            .padding(.top)
            
            Divider()
                .padding(5)
            
            HStack {
                Image(systemName: "clock")
                    .padding([.leading, .trailing])
                    .foregroundColor(Color(.green))
                    .font(.system(size: 18))
                Text(eventModel.selectedEvent?.time ?? "")
                    .font(.callout)
                Spacer()
            }
            
            Divider()
                .padding(5)
            
            HStack {
                Image(systemName: "book")
                    .padding([.leading, .trailing])
                    .foregroundColor(Color(.green))
                    .font(.system(size: 18))
                Text(eventModel.selectedEvent?.description ?? "")
                    .font(.callout)
                Spacer()
            }
            
            Divider()
                .padding(5)
            
            if let link = eventModel.selectedEvent?.link {
                if link != "" {
                    HStack {
                        Image(systemName: "link")
                            .padding([.leading, .trailing])
                            .foregroundColor(Color(.green))
                            .font(.system(size: 18))
                        Link("More information", destination: URL(string: link)!)
                            .font(.callout)
                        Spacer()
                    }
                }
            }
        }
        Spacer()
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

