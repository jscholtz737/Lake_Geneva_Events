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
                        }
                    }
                }
                else {
                    print(error?.localizedDescription ?? "db error")
                }
            }
        //STUCK HERE. want to add a function that adds recurring events to 'events'.  however, 'events' appears to
        //not yet be populated by the time code gets here.  Prob something to do with the async.  As a result,
        //cannot iterate over 'events'  to identify which ones have a 'weekly' or 'daily' recurring field
        //in firebase 'eventsV2.  Have to figure out how to delay the execution of this function until 'events'
        //is populated with Event objects.
    }
}
