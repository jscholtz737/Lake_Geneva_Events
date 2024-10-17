//
//  Event.swift
//  LGTv2
//
//  Created by Joseph Scholtz on 6/22/24.
//

import Foundation
import FirebaseFirestore

struct Event: Identifiable {
    
    var id: String
    var name: String
    var location: String
    var locationDetails: String
    var latitude: Double
    var longitude: Double
    var description: String
    var link: String
    var time: String
    var imageName: String
    var date: [String]
    
}
