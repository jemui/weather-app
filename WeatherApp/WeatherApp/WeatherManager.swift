//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Jeanette on 1/26/25.
//

import Foundation

protocol WeatherManangerDelegate: Sendable {
    func didUpdateWeather(weatherManager: WeatherManager, weatherModel: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager: Sendable{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?"
    var delegate: WeatherManangerDelegate?
    
    //fetch weather by city name
    func fetchWeather(cityName: String, metricType: String) {
        let apiKey = NetworkRequestManager.getAPIKey()
        let urlString = "\(weatherURL)appid=\(apiKey)&q=\(cityName)&units=\(metricType)"

        performRequest(urlString: urlString)
    }
    
    //fetch by location coordinates
    func fetchWeather(latitude: Double, longitute: Double, metricType: String) {
        let apiKey = NetworkRequestManager.getAPIKey()
        let urlString = "\(weatherURL)appid=\(apiKey)&lat=\(latitude)&lon=\(longitute)&units=\(metricType)"
        
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        let session = URLSession(configuration: .default)
        let networkTask = session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                guard let unwrappedError = error else { return }
                delegate?.didFailWithError(error: unwrappedError)
                return
            }
            
            guard let unwrappedData = data else {
                return
            }
//            let dataString = String(data: unwrappedData, encoding: .utf8)
//            print("[d] datastring<##> \(String(describing: dataString))")
            parseJSON(weatherData: unwrappedData)
        }
        
        networkTask.resume()
    }
    
    func parseJSON(weatherData: Data) {
        guard let delegate = delegate else {return}
        let decoder = JSONDecoder()
        
        do {
            let data = try decoder.decode(WeatherResponse.self, from: weatherData)
           
            let id = data.weather[0].id
            let temp = data.main.temp
            let name = data.name
            
            let weatherModel = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
            delegate.didUpdateWeather(weatherManager: self, weatherModel: weatherModel)
            
            print("weatherCondition: \(weatherModel.conditionName) temp: \(weatherModel.temperatureString)")
        } catch let error {
            print(error)
            delegate.didFailWithError(error: error)
        }
    }
    
    
}
