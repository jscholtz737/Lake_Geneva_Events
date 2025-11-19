//
//  EventModel.swift
//  LGTv2
//
//  Created by Joseph Scholtz on 6/28/24.
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseFirestore


@Observable class MapTabViewModel {
    
    var events: [Event]
    let date = Date()
    var selectedEvent: Event?
    
    init() {
        self.events = []
        self.getEvents(date: date)
    }
    
    func getEvents(date:Date) {
        
//        let calendar = Calendar.current
//        let startOfDay = calendar.startOfDay(for: date)
//        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {return}
            
        let db = Firestore.firestore()
            
        let events = db.collection("eventsV2")
        let query = events.whereField("endDate", isGreaterThan: date)
        query.getDocuments { QuerySnapshot, error in
                
                if error == nil {
                    //no errors
                    if let snapshot = QuerySnapshot {
                        //update the list properties in the main thread
                        DispatchQueue.main.async {
                            //get the documents and create Events
                            self.events = snapshot.documents.map { d in
                                
                                //create a Event item for each document returned
                                return Event(id: d.documentID, name: d["name"] as? String ?? "", location: d["location"] as? String ?? "", locationDetails: d["locationDetails"] as? String ?? "", latitude: d["latitude"] as? Double ?? 0, longitude: d["longitude"] as? Double ?? 0, description: d["description"] as? String ?? "", link: d["link"] as? String ?? "", time: d["time"] as? String ?? "", imageName: d["imageName"] as? String ?? "Generic", startDate: d["startDate"] as? Timestamp ?? Timestamp(), endDate: d["endDate"] as? Timestamp ?? Timestamp(), recurring: d["recurring"] as? String ?? "")
                            }
                            self.addRecurringEvents()
                        }
                    }
                }
                else {
                    print(error?.localizedDescription ?? "db error")
                }
            }
    }
    
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
    
    func addDailyEvents(event:Event) {
        
        let endDate = event.endDate.dateValue()
        var nextDate = event.startDate.dateValue()
         while true {
            nextDate = Calendar.current.date(byAdding: .day, value: 1, to: nextDate) ?? endDate
            if nextDate > endDate { break }
            var newEvent = event
            newEvent.startDate = Timestamp(date: nextDate)
            newEvent.endDate = Timestamp(date: nextDate)
            events.append(newEvent)
        }
    }
    
    func addWeeklyEvents(event:Event) {
        
        let endDate = event.endDate.dateValue()
        var nextDate = event.startDate.dateValue()
        while true {
            nextDate = Calendar.current.date(byAdding: .day, value: 7, to: nextDate) ?? endDate
            print("next date: \(nextDate) end date: \(endDate)")
            if nextDate > endDate { break }
            var newEvent = event
            newEvent.startDate = Timestamp(date: nextDate)
            newEvent.endDate = Timestamp(date: nextDate)
            events.append(newEvent)
        }
    }
    
    func printEvents() {
        for event in events {
            print("\(event.name) on \(event.startDate.dateValue())")
        }
    }
}

