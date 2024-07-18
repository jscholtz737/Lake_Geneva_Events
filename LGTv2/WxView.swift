//
//  WxView.swift
//  LGTv2
//
//  Created by Joseph Scholtz on 7/18/24.
//

import SwiftUI

struct WxView: View {
    
    @State var currentWx = Current()
    @ObservedObject var dataService = DataService()
    @State var skyIcon = "dashes"
    
    var body: some View {
       
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
    }
}

#Preview {
    WxView()
}
