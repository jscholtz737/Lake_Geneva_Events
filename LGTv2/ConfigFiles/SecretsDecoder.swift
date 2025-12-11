//
//  Untitled.swift
//  LGTv2
//
//  Created by Joseph Scholtz on 12/10/25.
//

import Foundation

enum Secrets {
    static var weatherAPIKey: String {
        guard let key = Bundle.main.infoDictionary?["WEATHER_API_KEY"] as? String else {
            fatalError("weather API key not found in Secrets.xconfig")
        }
        return key
    }
}
