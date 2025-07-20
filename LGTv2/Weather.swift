//
//  WeatherUpdate.swift
//  LGTv2
//
//  Created by Joseph Scholtz on 6/22/24.
//

import Foundation

struct Weather: Decodable {
    var location = Location()
    var current = Current()
}

struct Location: Decodable {
    var name: String?
    var region: String?
    var country: String?
    var lat: Double?
    var long: Double?
    var tz_id: String?
    var localtime_epoch: Int?
    var localtime: String?
}

struct Current: Decodable {
    var last_updated_epoch: Int?
    var last_updated: String?
    var temp_c: Double?
    var temp_f: Double?
    var is_day: Int?
    var condition = Condition()
    var wind_mph: Double?
    var wind_kph: Double?
    var wind_degree: Int?
    var wind_dir: String?
    var pressure_mb: Int?
    var pressure_in: Double?
    var precip_mm: Double?
    var precip_in: Double?
    var humidity: Int?
    var cloud: Int?
    var feelslike_c: Double?
    var feelslike_f: Double?
    var vis_km: Double?
    var vis_miles: Double?
    var uv: Double?
    var gust_mph: Double?
    var gust_kph: Double?
}
 
struct Condition: Decodable {
    var text: String?
    var icon: String?
    var code: Int?
}
