//
//  WxView.swift
//  LGTv2
//
//  Created by Joseph Scholtz on 7/18/24.
//

import SwiftUI

struct WxView: View {
    
    @Environment(CrowdModel.self) var crowdModel
    @State var currentWx = Current()
    @State var dataService:DataService = DataService()
    @State var skyIcon = ""
    
    var body: some View {
        
            HStack {
                currentWeather
                Spacer()
                expectedCrowds
                }
                .task {
                    currentWx = await dataService.getWeather()
                   if let code = currentWx.condition.code {
                        if let day = currentWx.is_day {
                            skyIcon = DataService.getIcon(code: code, day: day)
                        }
                    }
                }
                .padding(.bottom)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                        Task {
                            currentWx = await dataService.getWeather()
                            if let code = currentWx.condition.code {
                                if let day = currentWx.is_day {
                                    skyIcon = DataService.getIcon(code: code, day: day)
                                }
                            }
                        }
                }
        }
    }

// MARK : COMPONENTS

extension WxView {
    
    var currentWeather: some View {
        VStack (spacing: 0) {
            Text("Current Weather")
                .italic()
                .font(.subheadline)
                .padding(.leading)
                .padding(.top)
            
            if skyIcon == "" {
                Image(systemName: "network.slash")
                    .font(.system(size: 24))
                    .scaledToFit()
                    .frame(width: 48, height: 49)
            } else {
                Image(skyIcon)
            }
            
            HStack {
                if currentWx.temp_f == nil {
                    let stringTemp = "--"
                    Text(stringTemp + "°")
                        .padding(.trailing)
                        .font(.subheadline)
                } else {
                    let stringTemp = String(format: "%1.f", currentWx.temp_f ?? "--")
                    Text(stringTemp + "°")
                        .padding(.trailing)
                        .font(.subheadline)
                }
                
                Image(systemName: "wind")
                    .font(.system(size: 15))
                if currentWx.wind_mph == nil {
                    let stringWind = "--"
                    Text(stringWind)
                        .padding(.trailing)
                        .font(.subheadline)
                } else {
                    let stringWind = String(format: "%1.f", currentWx.wind_mph ?? "--")
                    Text(stringWind)
                        .padding(.trailing)
                        .font(.subheadline)
                }
        }
    }
    }
    
    var expectedCrowds: some View {
        VStack (spacing: 0) {
            Text ("Expected Crowds")
                .italic()
                .font(.subheadline)
                .padding(.trailing)
                .padding(.top)
            
            if crowdModel.crowds.isEmpty {
                Image(systemName: "person.fill.questionmark")
                    .font(.system(size: 24))
                    .scaledToFit()
                    .frame(width: 48, height: 49)
                    .padding(.trailing)
                Text("Unknown")
                    .font(.subheadline)
                    .padding(.trailing)
            } else {
                ForEach(crowdModel.crowds) {crowd in
                    switch crowd.level {
                    case "Low":
                        Image(systemName: "person.fill")
                            .foregroundColor(.green)
                            .font(.system(size: 24))
                            .scaledToFit()
                            .frame(width: 48, height: 49)
                            .padding(.trailing)
                    case "Moderate":
                        Image(systemName: "person.2.fill")
                            .foregroundColor(.orange)
                            .font(.system(size: 24))
                            .scaledToFit()
                            .frame(width: 48, height: 49)
                            .padding(.trailing)
                    case "Heavy":
                        Image(systemName: "person.3.fill")
                            .foregroundColor(.red)
                            .font(.system(size: 24))
                            .scaledToFit()
                            .frame(width: 48, height: 49)
                            .padding(.trailing)
                    default:
                        Image(systemName: "person.fill.xmark")
                            .font(.system(size: 24))
                            .scaledToFit()
                            .frame(width: 48, height: 49)
                            .padding(.trailing)
                    }
                    
                    Text(crowd.level)
                        .font(.subheadline)
                        .padding(.trailing)
                }
            }
        }
    }
}


#Preview {
    
    WxView()
        .environment(EventModel())
        .environment(CrowdModel())
    
}
