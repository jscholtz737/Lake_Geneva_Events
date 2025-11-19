//
//  EventDetailView.swift
//  LGTv2
//
//  Created by Joseph Scholtz on 6/22/24.
//

import SwiftUI

struct EventDetailView: View {
    
    @Environment(MapTabViewModel.self) var mapTabViewModel
    
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
            
            if let link = mapTabViewModel.selectedEvent?.link {
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

// MARK: COMPONENTS

extension EventDetailView {
    
    var eventPicture: some View {
        Image(mapTabViewModel.selectedEvent?.imageName ?? "Generic")
            .resizable()
            .frame(height: 200)
            .aspectRatio(contentMode: .fit)
            .clipped()
            .ignoresSafeArea()
            .opacity(0.3)
    }
    
    var eventName: some View {
        Text(mapTabViewModel.selectedEvent?.name ?? "")
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
            Text(mapTabViewModel.selectedEvent?.locationDetails ?? "")
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
            Text(mapTabViewModel.selectedEvent?.time ?? "")
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
            Text(mapTabViewModel.selectedEvent?.description ?? "")
                .font(.callout)
            Spacer()
        }
    }
}

#Preview {
    
    EventDetailView()
        .environment(MapTabViewModel())
    
}
