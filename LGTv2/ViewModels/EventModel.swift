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


@Observable class EventModel {
    
    var events: [Event]
    let date = Date()
    var selectedEvent: Event?
    
    init() {
        self.events = []
        self.getEvents(date: date)
    }
    
    func getEvents(date:Date) {
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {return}
            
        let db = Firestore.firestore()
            
        let events = db.collection("eventsV2")
        let query = events.whereField("date", isGreaterThan: startOfDay).whereField("date", isLessThan: endOfDay)
        query.getDocuments { QuerySnapshot, error in
                
                if error == nil {
                    //no errors
                    if let snapshot = QuerySnapshot {
                        //update the list properties in the main thread
                        DispatchQueue.main.async {
                            //get the documents and create Events
                            self.events = snapshot.documents.map { d in
                                
                                //create a Event item for each document returned
                                return Event(id: d.documentID, name: d["name"] as? String ?? "", location: d["location"] as? String ?? "", locationDetails: d["locationDetails"] as? String ?? "", latitude: d["latitude"] as? Double ?? 0, longitude: d["longitude"] as? Double ?? 0, description: d["description"] as? String ?? "", link: d["link"] as? String ?? "", time: d["time"] as? String ?? "", imageName: d["imageName"] as? String ?? "Generic", date: d["date"] as? Date ?? Date.distantFuture)
                            }
                        }
                    }
                }
                else {
                    print(error?.localizedDescription ?? "db error")
                }
            }
    }
    
    func getAllEvents() {

        let date = Date()
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
       
        let db = Firestore.firestore()
        
        let events = db.collection("eventsV2")
        let query = events.whereField("date", isGreaterThanOrEqualTo: startOfDay)
        query.getDocuments { QuerySnapshot, error in
            
            if error == nil {
                //no errors
                if let snapshot = QuerySnapshot {
                    //update te list properties in the main thread
                    DispatchQueue.main.async {
                        //get the documents and create Events
                        self.events = snapshot.documents.map { d in
                            
                            //create a Event item for each document returned
                            return Event(id: d.documentID, name: d["name"] as? String ?? "", location: d["location"] as? String ?? "", locationDetails: d["locationDetails"] as? String ?? "", latitude: d["latitude"] as? Double ?? 0, longitude: d["longitude"] as? Double ?? 0, description: d["description"] as? String ?? "", link: d["link"] as? String ?? "", time: d["time"] as? String ?? "", imageName: d["imageName"] as? String ?? "Generic", date: d["date"] as? Date ?? Date.distantFuture)
                        }
                    }
                }
            }
            else {
                print(error?.localizedDescription ?? "db error")
            }
        }
    }
}
