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
        VStack (spacing: -10) {
            
            if skyIcon == "" {
                Image(systemName: "network.slash")
                    .font(.system(size: 24))
                    .scaledToFit()
                    .frame(width: 48, height: 49)
            } else {
                Image(skyIcon)
            }
            
            if currentWx.temp_f == nil {
                let stringTemp = "--"
                Text(stringTemp + "°")
                    .padding(.trailing)
                    .font(.subheadline)
            } else {
                let stringTemp = String(format: "%1.f", currentWx.temp_f ?? "--")
                Text(stringTemp + "°")
                    .font(.subheadline)
            }
        }
    }
}

#Preview {
    
    WxView()
        .environment(MapTabViewModel())
        .environment(CrowdModel())
    
}
