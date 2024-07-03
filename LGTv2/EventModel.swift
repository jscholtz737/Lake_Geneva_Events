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

@Observable
class EventModel: ObservableObject {
    
    var events = [Event]()
    
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
                            return Event(id: d.documentID, name: d["name"] as? String ?? "", location: d["location"] as? String ?? "", latitude: d["latitude"] as? Double ?? 0, longitude: d["longitude"] as? Double ?? 0, description: d["description"] as? String ?? "", time: d["time"] as? String ?? "", imageName: d["imageName"] as? String ?? "")
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
