//
//  WeatherModel.swift
//  Location
//
//  Created by Jonathan Heinzman on 7/29/26.
//

import Foundation

// WEATHER RESPONSE FROM THE API

struct WeatherResponse: Codable {
    let current: CurrentWeather
}


// CURRENT WEATHER INFORMATION

struct CurrentWeather: Codable {
    
    let temperature: Double
    let weatherCode: Int
    let windSpeed: Double
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temperature_2m"
        case weatherCode = "weather_code"
        case windSpeed = "wind_speed_10m"
    }
    
   
}
