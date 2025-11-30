//
//  WxView.swift
//  LGTv2
//
//  Created by Joseph Scholtz on 7/18/24.
//

import SwiftUI

struct WxView: View {
    
    @Environment(MapTabViewModel.self) var mapTabViewModel
    @State var currentWx = Current()
    @State var skyIcon = ""
    
    var body: some View {
        
           // HStack {
                currentWeather
             //   }
                .task {
                    currentWx = await DataService.shared.getWeather()
                   if let code = currentWx.condition.code {
                        if let day = currentWx.is_day {
                            skyIcon = mapTabViewModel.getWeatherIcon(code: code, day: day)
                        }
                    }
                }
                .padding(.bottom)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                        Task {
                            currentWx = await DataService.shared.getWeather()
                            if let code = currentWx.condition.code {
                                if let day = currentWx.is_day {
                                    skyIcon = mapTabViewModel.getWeatherIcon(code: code, day: day)
                                }
                            }
                        }
                }
        }
    }

// MARK : COMPONENTS

extension WxView {
    
    var currentWeather: some View {
        HStack (alignment: .bottom, spacing: -10) {
            
            if currentWx.temp_f == nil {
                let stringTemp = "--"
                Text(stringTemp + "°")
                    .padding(.trailing)
            } else {
                let stringTemp = String(format: "%1.f", currentWx.temp_f ?? "--")
                Text(stringTemp + "°")
                    .padding(.trailing)
            }
            
            if skyIcon == "" {
                Image(systemName: "network.slash")
                    .font(.system(size: 24))
                    .scaledToFit()
                    .frame(width: 48, height: 49)
                    .padding()
                    .offset(y: 12)
                
            } else {
                Image(skyIcon)
                    .offset(y: 12)
            }
        }
        .font(.title3)
        .foregroundStyle(Color.white)
    }
}

#Preview {
    
    WxView()
        .environment(MapTabViewModel())
   
    
}
