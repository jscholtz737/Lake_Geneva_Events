//
//  EventDetailView.swift
//  LGTv2
//
//  Created by Joseph Scholtz on 6/22/24.
//

import SwiftUI
import FirebaseFirestore

struct EventDetailView: View {
    
    let event: Event
    
    var body: some View {
        
    
        ZStack {
         
            VStack(spacing: 12) {
                eventName
            
                eventLocation
                Divider().padding(.vertical, 5)
                
                eventDate
                Divider().padding(.vertical, 5)
                
                eventTime
                Divider().padding(.vertical, 5)
                
                eventDescription
                Divider().padding(.vertical, 5)
                
                if event.link != "" {
                    let link = event.link
                    HStack {
                        Image(systemName: "link")
                            .padding([.leading, .trailing])
                            .foregroundColor(Color(.green))
                            .font(.title3)
                        Link("More information", destination: URL(string: link) ?? URL(string: "https://www.google.com")!)
                            .font(.callout)
                        Spacer()
                    }
                }
                Spacer()
            }
            .padding(.top, 50)
        }
                .background(
                    backgroundPicture
                )
    }
}

// MARK: COMPONENTS

extension EventDetailView {
    
    var backgroundPicture: some View {
        Image(event.imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea()
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .clipped()
            .overlay(Color.sheet.opacity(0.8))
            .blur(radius: 1)
    }
    
    var eventName: some View {
        Text(event.name)
            .font(.largeTitle)
            .bold()
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .minimumScaleFactor(0.7)
            .allowsTightening(true)
            .padding([.leading, .trailing])
    }
    
    var eventDate: some View {
        HStack {
            Image(systemName: "calendar")
                .padding([.leading, .trailing])
                .foregroundColor(Color(.green))
                .font(.title3)
            Text(event.startDate.dateValue().formatted(.dateTime.weekday(.wide).month(.wide).day()))
                .font(.callout)
            Spacer()
        }
    }
    
    var eventLocation: some View {
        HStack{
            Image(systemName: "location")
                .padding([.leading, .trailing])
                .foregroundColor(Color(.green))
                .font(.title3)
            Text(event.locationDetails)
                .font(.callout)
            Spacer()
        }
        .padding(.top, 50)
    }
    
    var eventTime: some View {
        HStack {
            Image(systemName: "clock")
                .padding([.leading, .trailing])
                .foregroundColor(Color(.green))
                .font(.title3)
            Text(event.time)
                .font(.callout)
            Spacer()
        }
    }
    
    var eventDescription: some View {
        HStack {
            Image(systemName: "book")
                .padding([.leading, .trailing])
                .foregroundColor(Color(.green))
                .font(.title3)
            Text(event.description)
                .font(.callout)
            Spacer()
        }
    }
}

#Preview {
    EventDetailView(event: Event(id: "2", name: "Gingerbread House Walkway Parade Route", location: "Lake Geneva", locationDetails: "The Beach", latitude: 42.59157613156, longitude: 88.43599431381, description: "A test event for fun", link: "https://www.google.com/", time: "3pm-4pm", imageName: "LakeGeneva", startDate: Timestamp(date: Date()), endDate: Timestamp(date: Date()), recurring: "daily"))
        .padding()
}
