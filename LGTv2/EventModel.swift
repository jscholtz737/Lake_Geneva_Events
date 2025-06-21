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
    
    var events = [Event]()
    var selectedEvent: Event?
    var date = Date()
    var crowds = [Crowds]()
    
    func getEvents() {

        let dtFormatter = DateFormatter()
        dtFormatter.dateStyle = .short

        let formattedDate = dtFormatter.string(from: date)
        
        let db = Firestore.firestore()
        
        let events = db.collection("events")
        let query = events.whereField("date", arrayContainsAny:[formattedDate])
        query.getDocuments { QuerySnapshot, error in
            
            if error == nil {
                //no errors
                if let snapshot = QuerySnapshot {
                    //update te list properties in the main thread
                    DispatchQueue.main.async {
                        //get the documents and create Events
                        self.events = snapshot.documents.map { d in
                            
                            //create a Event item for each document returned
                            return Event(id: d.documentID, name: d["name"] as? String ?? "", location: d["location"] as? String ?? "", locationDetails: d["locationDetails"] as? String ?? "", latitude: d["latitude"] as? Double ?? 0, longitude: d["longitude"] as? Double ?? 0, description: d["description"] as? String ?? "", link: d["link"] as? String ?? "", time: d["time"] as? String ?? "", imageName: d["imageName"] as? String ?? "", date: d["date"] as? [String] ?? [""])
                        }
                    }
                }
            }
            else {
                print(error?.localizedDescription ?? "db error")
            }
        }
    }
    
    func getCrowds() {

        let dtFormatter = DateFormatter()
        dtFormatter.dateStyle = .short

        let formattedDate = dtFormatter.string(from: date)
        
        let db = Firestore.firestore()
        
        let crowds = db.collection("crowds")
        let query = crowds.whereField("date", isEqualTo:formattedDate)
        query.getDocuments { QuerySnapshot, error in
            
            if error == nil {
                //no errors
                if let snapshot = QuerySnapshot {
                    //update the list properties in the main thread
                    DispatchQueue.main.async {
                        //get the documents and create Crowds
                        self.crowds = snapshot.documents.map { d in
                            
                            //create a Crowds item for each document returned
                            return Crowds(id: d.documentID, date: d["date"] as? String ?? "x", level: d["level"] as? String ?? "x")
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
