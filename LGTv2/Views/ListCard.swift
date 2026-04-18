//
//  ListCard.swift
//  LGTv2
//
//  Created by Joseph Scholtz on 11/21/25.
//

import SwiftUI
import FirebaseFirestore

struct ListCard: View {
    
    let event: Event
    
    var body: some View {
        HStack{
            if let url = URL(string: event.imageName) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemGray4))
                            .frame(width: 75.0, height: 75.0)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 75.0, height: 75.0)
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    case .failure:
                        Image("LakeGeneva")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 75.0, height: 75.0)
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image("LakeGeneva")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 75.0, height: 75.0)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
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
        .padding(5)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(.systemGray6))
        )
    }
}

#Preview {
    ListCard(event: Event(id: "2", name: "Test", location: "Lake Geneva", locationDetails: "The Beach", latitude: 42.59157613156, longitude: 88.43599431381, description: "A test event for fun", link: "https://www.google.com/", time: "3pm-4pm", imageName: "LakeGeneva", startDate: Timestamp(date: Date()), endDate: Timestamp(date: Date()), recurring: "daily"))
        .padding()
}
