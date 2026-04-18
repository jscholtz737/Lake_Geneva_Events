//
//  MapCard.swift
//  LGTv2
//
//  Created by Joseph Scholtz on 12/4/25.
//

import SwiftUI
import FirebaseFirestore

struct MapCard: View {
    
    @State private var isShowingDetails = false
    var cardEvent: Event
    
    var body: some View {
        HStack (alignment: .bottom) {
            VStack (alignment: .leading){
                imageSection
                titleSection
            }
            Spacer()
            VStack (alignment: .trailing, spacing: 50) {
                detailsSection
                detailsButton
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10)
            .fill(.ultraThinMaterial)
            .offset(y:40)
        )
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .sheet(isPresented: $isShowingDetails) {
            EventDetailView(event: cardEvent)
                .presentationDetents([.medium, .large])
        }
        }
    }

extension MapCard {
    
    private var imageSection: some View {
        ZStack {
            if let url = URL(string: cardEvent.imageName) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 80, height: 80)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 15)
                    case .failure:
                        Image("LakeGeneva")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 15)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image("LakeGeneva")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 15)
            }
        }
        .padding(6)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(cardEvent.name)
                .font(.title3)
                .fontWeight(.bold)
                .lineLimit(2)
                .minimumScaleFactor(0.7)
                .allowsTightening(true)
            
            Text(cardEvent.location)
                .font(.subheadline)
        }
    }
    
    private var detailsSection: some View {
        
        VStack (alignment: .trailing) {
            Text(cardEvent.time)
                .font(.headline)
                .italic()
                .lineLimit(2)
                .minimumScaleFactor(0.7)
                .allowsTightening(true)
        }
        }
        
    private var detailsButton: some View {
        
        Button {
            isShowingDetails = true
        } label: {
            Text("Details")
                .font(.headline)
            .frame(width: 100)
        }
        .tint(.mint)
        .buttonStyle(.borderedProminent)
        .controlSize(.small)
        .shadow(radius: 15)
        }
}

#Preview {
    
    ZStack {
        Color.blue
        MapCard(cardEvent: Event(id: "2", name: "Test Event", location: "Lake Geneva", locationDetails: "The Beach", latitude: 42.59157613156, longitude: 88.43599431381, description: "A test event for fun", link: "https://www.google.com/", time: "Time varies: 3pm-4pm", imageName: "LakeGeneva", startDate: Timestamp(date: Date()), endDate: Timestamp(date: Date()), recurring: "daily"))
    }
}

