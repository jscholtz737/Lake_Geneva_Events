//
//  WxView.swift
//  LGTv2
//
//  Created by Joseph Scholtz on 7/18/24.
//

import SwiftUI

struct WxView: View {
    
    @Environment(EventModel.self) var eventModel
    @State var currentWx = Current()
    @ObservedObject var dataService = DataService()
    @State var skyIcon = "dashes"
    
    var body: some View {
        
            HStack{
                VStack (spacing: 0) {
                    Text("Current Weather")
                        .italic()
                        .font(.subheadline)
                        .padding(.leading)
                        .padding(.top)
                    Image(skyIcon)
                    HStack {
                        let stringTemp = String(format: "%1.f", currentWx.temp_f ?? "--")
                        Text(stringTemp + "°")
                            .padding(.trailing)
                            .font(.subheadline)
                        let stringWind = String(format: "%1.f", currentWx.wind_mph ?? "--")
                        Image(systemName: "wind")
                            .font(.system(size: 15))
                        Text(stringWind)
                            .font(.subheadline)
                }
            }
                Spacer()
                VStack (spacing: 0) {
                    Text ("Expected Crowds")
                        .italic()
                        .font(.subheadline)
                        .padding(.trailing)
                        .padding(.top)
                    ForEach(eventModel.crowds) {crowd in
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
                            Image("person.fill.questionmark")
                        }
                           
                        Text(crowd.level)
                            .font(.subheadline)
                            .padding(.trailing)
                    }
                }
                .onAppear {
                    eventModel.getCrowds()
                }
                .onChange(of: eventModel.date) {
                    eventModel.getCrowds()
                }
                }
                .task {
                    currentWx = await dataService.getWeather()
                    if let code = currentWx.condition.code {
                        if let day = currentWx.is_day {
                            skyIcon = SkyCond.getIcon(code: code, day: day)
                        }
                    }
                }
                .padding(.bottom)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                        Task {
                            currentWx = await dataService.getWeather()
                            if let code = currentWx.condition.code {
                                if let day = currentWx.is_day {
                                    skyIcon = SkyCond.getIcon(code: code, day: day)
                                }
                            }
                        }
                }
        }
    }


#Preview {
    WxView(currentWx: Current(temp_f: 80), skyIcon: "113")
}
