//
//  DataService.swift
//  LGTv2
//
//  Created by Joseph Scholtz on 6/22/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

struct DataService {
    
    func getData() -> [Event] {
        
        let db = Firestore.firestore()
        let events = db.collection("events")
        events.getDocuments { querySnapshot, error in
            if let error = error {
                print(error.localizedDescription)
            } else if let querySnapshot = querySnapshot {
                for doc in querySnapshot.documents {
                    print(doc.data())
                }
            } else {
                //no data returned
            }
        }
        return [Event(name: "A Festival",
                      location: "Lake Geneva",
                      description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
                      time: "8am-10pm",
                      imageName: "festival"),
                Event(name: "Lakefest",
                      location: "Fontana",
                      description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
                      time: "10am-1pm",
                      imageName: "lake"),
                Event(name: "Farmers Market",
                      location: "Williams Bay",
                      description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
                      time: "10:30am-10:30pm",
                      imageName: "festival"),
                Event(name: "Venetian Fest",
                      location: "Lake Geneva",
                      description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
                      time: "9:30am-5pm",
                      imageName: "lake"),        ]
    }
    
    func getWeather() async -> Current {
        
        //check if api key exists
        
        //1. create url
        if let url = URL(string:"https://api.weatherapi.com/v1/current.json?key=a30a1d5265d04306a3c30909241905&q=53147&aqi=no") {
            
            //2. create request
            let request = URLRequest(url: url)
            
            //3. send request
            do {
                let (data,_) = try await URLSession.shared.data(for: request)
                
                //4. parse the json
                let decoder = JSONDecoder()
                let result = try decoder.decode(WeatherUpdate.self, from: data)
                return result.current
            }
            catch {
                print(error)
            }
        }
        return Current()
    }
}

