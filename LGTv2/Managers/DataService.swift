//
//  DataService.swift
//  LGTv2
//
//  Created by Joseph Scholtz on 6/22/24.
//

import Foundation
//import FirebaseCore
import FirebaseFirestore

final actor DataService {
    
    static let shared = DataService()
    var events: [Event] = []
    var date = Date() 
    var crowds: [Crowds] = []
    
//    called from maptabviewmodel, on appear map view. gets all events from firebase and assigns them to DataService.events.  Then calls addRecurringEvents
    func getFirebaseEvents() async {
        let db = Firestore.firestore()
        let eventsCollection = db.collection("events")
        let query = eventsCollection.whereField("endDate", isGreaterThan: date)
        do {
            let snapshot = try await query.getDocuments()
                self.events = snapshot.documents.map { d in
                    return Event(
                        id: d.documentID,
                        name: d["name"] as? String ?? "",
                        location: d["location"] as? String ?? "",
                        locationDetails: d["locationDetails"] as? String ?? "",
                        latitude: d["latitude"] as? Double ?? 0,
                        longitude: d["longitude"] as? Double ?? 0,
                        description: d["description"] as? String ?? "",
                        link: d["link"] as? String ?? "",
                        time: d["time"] as? String ?? "",
                        imageName: d["imageName"] as? String ?? "Generic",
                        startDate: d["startDate"] as? Timestamp ?? Timestamp(),
                        endDate: d["endDate"] as? Timestamp ?? Timestamp(),
                        recurring: d["recurring"] as? String ?? ""
                    )
                }
                self.addRecurringEvents()
        } catch {
            print(error.localizedDescription)
        }
    }
    
//    loops through events. if event is one-time, breaks.  Otherwise calls addDailyEvents for multiday event, and addWeeklyEvents for weekly events
    func addRecurringEvents() {
        for event in events {
            switch event.recurring {
            case "":
                break
            case "daily":
                addDailyEvents(event: event)
            case "weekly":
                addWeeklyEvents(event: event)
            default:
                break
            }
        }
    }
    
    //called from addRecurringEvents if event is marked as 'daily' (multiday event) and appends them to DataService.events
    func addDailyEvents(event:Event) {
        
        let endDate = event.endDate.dateValue()
        var nextDate = event.startDate.dateValue()
         while true {
            nextDate = Calendar.current.date(byAdding: .day, value: 1, to: nextDate) ?? endDate
            if nextDate > endDate { break }
            var newEvent = event
            newEvent.startDate = Timestamp(date: nextDate)
            newEvent.endDate = Timestamp(date: nextDate)
             //add 16 hours to the timestamp so event doesn't get filtered out with Date() filters.  Need to fix for DST at some point
             let currentEnd = newEvent.endDate.dateValue()
             if let plus16 = Calendar.current.date(byAdding: .hour, value: 16, to: currentEnd) {
                 newEvent.endDate = Timestamp(date: plus16)
             }
            newEvent.id = UUID().uuidString
            events.append(newEvent)
        }
    }
    
    //called from addRecurringEvents if event is marked as 'weekly' (weekly event) and appends them to DataService.events
    func addWeeklyEvents(event:Event) {
        
        let endDate = event.endDate.dateValue()
        var nextDate = event.startDate.dateValue()
        while true {
            nextDate = Calendar.current.date(byAdding: .day, value: 7, to: nextDate) ?? endDate
            if nextDate > endDate { break }
            var newEvent = event
            newEvent.startDate = Timestamp(date: nextDate)
            newEvent.endDate = Timestamp(date: nextDate)
            //add 16 hours to the timestamp so event doesn't get filtered out with Date() filters.  Need to fix for DST at some point
            let currentEnd = newEvent.endDate.dateValue()
            if let plus16 = Calendar.current.date(byAdding: .hour, value: 16, to: currentEnd) {
                newEvent.endDate = Timestamp(date: plus16)
            }
            newEvent.id = UUID().uuidString
            events.append(newEvent)
        }
    }
    
    //called from wxview once, not updated.  Current wx only
    func getWeather() async -> Current {
        
        //check if api key exists
        
        //1. create url
        let key = Secrets.weatherAPIKey
        if let url = URL(string:"https://api.weatherapi.com/v1/current.json?key=\(key)&q=53147&aqi=no") {
            
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
    
    //    called from maptabviewmodel, on appear map view and on date change. saves in .,crowds
    func getFirebaseCrowdData(date: Date) async {
        
        let dtFormatter = DateFormatter()
        dtFormatter.dateStyle = .short

        let formattedDate = dtFormatter.string(from: date)
     
        let db = Firestore.firestore()
        
        let crowdsCollection = db.collection("crowds")
        let query = crowdsCollection.whereField("date", isEqualTo: formattedDate)
         do {
            let snapshot = try await query.getDocuments()
            self.crowds = snapshot.documents.map { d in
                return Crowds(
                    id: d.documentID,
                    date: d["date"] as? String ?? "x",
                    level: d["level"] as? String ?? "x"
                )
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}


