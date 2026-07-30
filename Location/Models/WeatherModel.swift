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

// WEATHER CONDITION OPTIONS

enum WeatherCondition: String {
    case clear = "Clear"
    case cloudy = "Cloudy"
    case foggy = "Foggy"
    case rain = "Rain"
    case snow = "Snow"
    case rainShowers = "Rain Showers"
    case thunderstorm = "Thunderstorm"
    case unknown = "Unknown"
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
    
    var condition: WeatherCondition {
        switch weatherCode {
        case 0:
            return .clear
            
        case 1...3:
            return .cloudy
            
        case 45, 48:
            return .foggy
            
        case 51...67:
            return .rain
            
        case 71...77:
            return .snow
            
        case 80...82:
            return .rainShowers
            
        case 95...99:
            return .thunderstorm
            
        default:
            return .unknown
        }
    }
}
