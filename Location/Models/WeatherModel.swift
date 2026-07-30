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
    
    func weatherCondition(
            code: Int
        ) -> String {
            
            switch code {
            case 0:
                return "Clear"
                
            case 1...3:
                return "Cloudy"
                
            case 45, 48:
                return "Foggy"
                
            case 51...67:
                return "Rain"
                
            case 71...77:
                return "Snow"
                
            case 80...82:
                return "Rain Showers"
                
            case 95...99:
                return "Thunderstorm"
                
            default:
                return "Unknown"
            }
        }
}
