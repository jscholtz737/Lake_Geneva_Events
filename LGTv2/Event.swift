//
//  Event.swift
//  LGTv2
//
//  Created by Joseph Scholtz on 6/22/24.
//

import Foundation

struct Event: Identifiable {
    
    let id = UUID()
    var name: String
    var location: String
    var description: String
    var time: String
    var imageName: String
    
}
