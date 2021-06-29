//
//  WeatherData.swift
//  Weather
//
//  Created by Vamsi Krishna on 25/02/21.
//

import Foundation
struct WeatherData:Codable {
    var name:String
    var main:Main
    var weather:[Weather]
}

struct Main:Codable {
    var temp:Double
}

struct Weather:Codable{
    var id:Int
    var description:String
}

