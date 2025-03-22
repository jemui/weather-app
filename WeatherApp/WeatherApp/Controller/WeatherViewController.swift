//
//  ViewController.swift
//  WeatherApp
//
//  Created by Jeanette on 3/20/25.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.delegate = self
        locationManager.requestLocation()
        
        searchTextField.delegate = self
        weatherManager.delegate = self
    }
    
    // request location when search button is pressed
    @IBAction func buttonPressed(_ sender: UIButton) {
        locationManager.requestLocation()
        
    }
    
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        if text.isEmpty {
            textField.placeholder = "Type something"
            return false
        } else {
            return true
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        //get weather
        weatherManager.fetchWeather(cityName: (textField.text ?? "San Francisco"), metricType: "imperial")
        textField.placeholder = "Search"
        textField.text = ""
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManangerDelegate {
    
    nonisolated func didUpdateWeather(weatherManager: WeatherManager, weatherModel: WeatherModel) {
        Task { @MainActor in
            self.temperatureLabel.text = weatherModel.temperatureString
            self.conditionImageView.image = UIImage(systemName: weatherModel.conditionName)
            self.cityLabel.text = weatherModel.cityName
        }
    }
    
    nonisolated func didFailWithError(error: any Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: @preconcurrency CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print("did update locations")
        guard let location = locations.last else { return }
        locationManager.stopUpdatingLocation()
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        
        weatherManager.fetchWeather(latitude: lat, longitute: lon, metricType: "imperial")
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("failed to get location: \(error.localizedDescription)")
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        print("resume location update")
    }
}
