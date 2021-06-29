//
//  WeatherManager.swift
//  Weather
//
//  Created by Vamsi Krishna on 24/02/21.
//


import UIKit
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weather:WeatherModel)
    func didFailWithError(error:Error)
}
struct WeatherManager {
    let URL = "https://api.openweathermap.org/data/2.5/weather?appid=71baae580d874972a49b116b57593287&units=metric"
    var delegate: WeatherManagerDelegate?
    
    //MARK: - Fetch Weather based on city name
    func fetchWeather(city:String){
        let urlString = URL+"&q="+city
        performRequest(urlString)
    }
    //MARK: - Fetch Weather based on coordinates
    func fetchWeather(lat:CLLocationDegrees,lon:CLLocationDegrees){
        let liveURL = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=71baae580d874972a49b116b57593287&units=metric"
        performRequest(liveURL)
    }
    
    func performRequest(_ urlString:String){
        if let url = Foundation.URL(string: urlString){
            let session = Foundation.URLSession(configuration: .default)
            let urlrequest = Foundation.URLRequest(url: url)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = parseJSON(safeData){
                        self.delegate?.didUpdateWeather(weather:weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data:Data)->WeatherModel? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: data)
             return WeatherModel(cityName: decodedData.name, id: decodedData.weather[0].id, temperature: decodedData.main.temp, description: decodedData.weather[0].description)
        }catch{
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    
}
