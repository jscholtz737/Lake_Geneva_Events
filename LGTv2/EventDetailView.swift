//
//  EventDetailView.swift
//  LGTv2
//
//  Created by Joseph Scholtz on 6/22/24.
//

import SwiftUI

struct EventDetailView: View {
    
    var event:Event?
    
    var body: some View {
        ZStack{
            Image(event?.imageName ?? "")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
                .ignoresSafeArea()
                .opacity(0.5)
        
            VStack{
                Text(event?.name ?? "")
                Text(event?.location ?? "")
                Text(event?.time ?? "")
                Text(event?.description ?? "")
            }
            .padding(.leading)
            .padding(.trailing)
        }
    }
}
