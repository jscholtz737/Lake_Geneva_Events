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
                        Image("wind")
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
                    Image(systemName: "person.fill")
                        .foregroundColor(.green)
                        .font(.system(size: 44))
                        .padding(9)
                    Text("Light")
                        .font(.subheadline)
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
        }
    }


#Preview {
    WxView(currentWx: Current(temp_f: 80), skyIcon: "113")
}
