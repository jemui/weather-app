//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Jeanette on 1/27/25.

//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Float
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    var conditionName: String {
        //2xx - thunderstorm
        //3xx - drizzle
        //5xx - rain
        //6xx - snow
        //7xx - atmosphere
        //800 - clear
        //80x - clouds
        switch conditionId {
        case 200 ..< 300:
            return "cloud.bolt"
        case 300 ..< 400:
            return "cloud.drizzle"
        case 500 ..< 600:
            return "cloud.rain"
        case 600 ..< 700:
            return "cloud.fog"
        case 800:
            return "sun.min"
        case 801 ..< 810:
            return "cloud"
        default:
            return "sun.max"
        }
    }
    
}
