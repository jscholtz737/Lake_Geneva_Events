//
//  CrowdModel.swift
//  LGTv2
//
//  Created by Joseph Scholtz on 6/21/25.
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseFirestore


@Observable class CrowdModel {
    
    var crowds: [Crowds]
    var date = Date()
    
    init() {
        self.crowds = []
        self.getCrowds(date: date)
    }
    
    func getCrowds(date:Date) {

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
