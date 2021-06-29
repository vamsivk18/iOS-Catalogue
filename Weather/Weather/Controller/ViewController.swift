//
//  ViewController.swift
//  Weather
//
//  Created by Vamsi Krishna on 24/02/21.
//

import UIKit
import CoreLocation

class ViewController: UIViewController  {
    
    var Weather = WeatherManager()
    var locationManager = CLLocationManager()
    
    var lat:Double = 0.0
    var lon:Double = 0.0
    
    @IBOutlet weak var imageType: UIImageView!
    
    @IBOutlet weak var cityText: UITextField!
    
    @IBOutlet weak var descriptionText: UILabel!
    
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    override func viewDidLoad() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        super.viewDidLoad()
        Weather.delegate = self
        cityText.delegate = self
            }
    @IBAction func currentLocation(_ sender: UIButton) {
        Weather.fetchWeather(lat:lat,lon:lon)
    }
}

//MARK: - UItextFieldDelegate Extension

extension ViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        cityText.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        cityText.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if cityText.text! == "" {
            cityText.placeholder = "Type a City name"
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = cityText.text {
            Weather.fetchWeather(city: city)
        }
        cityText.text = ""
    }
}

//MARK: - WeatherManagerDelegate Extension

extension ViewController:WeatherManagerDelegate{
    func didUpdateWeather(weather:WeatherModel){
        DispatchQueue.main.async {
            self.tempLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.imageType.image = UIImage(systemName: weather.conditionName)
            self.descriptionText.text = weather.description
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: -  CLLocationManagerDelegate

extension ViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            lat = location.coordinate.latitude
            lon = location.coordinate.longitude
            Weather.fetchWeather(lat:lat,lon:lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

