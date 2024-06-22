//
//  ContentView.swift
//  LGTv2
//
//  Created by Joseph Scholtz on 6/22/24.
//

import SwiftUI
import Foundation

struct ContentView: View {
    
    @State var currentWx = Current()
    @State var events = [Event]()
    var dataService = DataService()
    @State var skyIcon = ""
    
    var body: some View {
        
        VStack {
            Text("Lake Geneva Today")
                .font(.largeTitle)
                .italic()
                .bold()
                
            
            Text(Date().formatted(.dateTime.weekday(.wide).month(.wide).day()))
                .font(.title2)
            
            HStack{
                Spacer()
                let stringTemp = String(format: "%1.f", currentWx.temp_f ?? "--")
                Text(stringTemp + "°")
                Spacer()
                Image(skyIcon)
                Spacer()
                HStack {
                    let stringWind = String(format: "%1.f", currentWx.wind_mph ?? "--")
                    Image("wind")
                    Text(stringWind)
                }
                Spacer()
            }
            .font(.title2)
            .task {
                currentWx = await dataService.getWeather()
                if let code = currentWx.condition.code {
                    if let day = currentWx.is_day {
                        skyIcon = SkyCond.getIcon(code: code, day: day)
                    }
                }
            }
            .padding()
            
            Image("LakeSilouette")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Divider()
            
            NavigationStack{
                List {
                    ForEach(events) {event in
                        NavigationLink {
                            EventDetailView(event: event)
                        } label: {
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
                        }
                    }
                }
                .onAppear {
                    events = dataService.getData()
                }
                .listStyle(.plain)
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
