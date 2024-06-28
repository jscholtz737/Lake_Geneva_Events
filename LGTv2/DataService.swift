//
//  DataService.swift
//  LGTv2
//
//  Created by Joseph Scholtz on 6/22/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class DataService: ObservableObject {
    
    @Published var events = [Event]()
    
    
    func getEvents() {
      
        let db = Firestore.firestore()
        db.collection("events").getDocuments { snapshot, error in
            if error == nil {
                //no errors
                if let snapshot = snapshot {
                    
                    //update te list properties in the main thread
                    DispatchQueue.main.async {
                        //get the documents and create Events
                        self.events = snapshot.documents.map { d in
                            
                            //create a Event item for each document returned
                            return Event(id: d.documentID, name: d["name"] as? String ?? "", location: d["location"] as? String ?? "", description: d["description"] as? String ?? "", time: d["time"] as? String ?? "", imageName: d["imageName"] as? String ?? "")
                        }
                    }
                }
            }
            else {
                print(error?.localizedDescription ?? "db error")
            }
        }
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

