//
//  NetworkRequestManager.swift
//  WeatherApp
//
//  Created by Jeanette on 1/26/25.

//

import Foundation

class NetworkRequestManager {
    
    static func getAPIKey() -> String {
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
           let secrets = NSDictionary(contentsOfFile: path) as? [String: Any],
           let apiKey = secrets["API_KEY"] as? String {
            return apiKey
        }
        return ""
    }
  
}
