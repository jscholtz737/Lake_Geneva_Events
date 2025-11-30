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
        VStack{
            eventPicture
            eventName
        }
        VStack {
            eventLocation
            
            Divider()
                .padding(5)
            
            eventTime
            
            Divider()
                .padding(5)
            
            eventDescription
            
            Divider()
                .padding(5)
            
                if event.link != "" {
                    let link = event.link
                    HStack {
                        Image(systemName: "link")
                            .padding([.leading, .trailing])
                            .foregroundColor(Color(.green))
                            .font(.system(size: 18))
                        Link("More information", destination: URL(string: link) ?? URL(string: "https://www.google.com")!)
                            .font(.callout)
                        Spacer()
                    }
                }
            
        }
        Spacer()
    }
     
}

// MARK: COMPONENTS

extension EventDetailView {
    
    var eventPicture: some View {
        Image(event.imageName)
            .resizable()
            .frame(height: 200)
            .aspectRatio(contentMode: .fit)
            .clipped()
            .ignoresSafeArea()
            .opacity(0.3)
    }
    
    var eventName: some View {
        Text(event.name)
            .font(.largeTitle)
            .bold()
            .padding()
            .multilineTextAlignment(.center)
    }
    
    var eventLocation: some View {
        HStack{
            Image(systemName: "location")
                .padding([.leading, .trailing])
                .foregroundColor(Color(.green))
                .font(.system(size: 18))
            Text(event.locationDetails)
                .font(.callout)
            Spacer()
        }
        .padding(.top)
    }
    
    var eventTime: some View {
        HStack {
            Image(systemName: "clock")
                .padding([.leading, .trailing])
                .foregroundColor(Color(.green))
                .font(.system(size: 18))
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
                .font(.system(size: 18))
            Text(event.description)
                .font(.callout)
            Spacer()
        }
    }
}

#Preview {
    ListCard(event: Event(id: "2", name: "Test", location: "Lake Geneva", locationDetails: "The Beach", latitude: 42.59157613156, longitude: 88.43599431381, description: "A test event for fun", link: "https://www.google.com/", time: "3pm-4pm", imageName: "LakeGeneva", startDate: Timestamp(date: Date()), endDate: Timestamp(date: Date()), recurring: "daily"))
        .padding()
}
