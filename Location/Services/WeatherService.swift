//
//  WeatherService.swift
//  Location
//
//  Created by Jonathan Heinzman on 7/29/26.
//

import Foundation


enum WeatherError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The weather URL could not be created."
            
        case .invalidResponse:
            return "The weather request failed."
            
        case .decodingError:
            return "The weather data could not be read."
        }
    }
}


class WeatherService {
    
    // GET WEATHER USING THE CURRENT COORDINATES
    
    func fetchWeather(
        latitude: Double,
        longitude: Double
    ) async throws -> CurrentWeather {
        
        // URLCOMPONENTS IS USED TO SAFELY BUILD THE URL
        
        var urlComponents: URLComponents = URLComponents()
        
        urlComponents.scheme = "https"
        urlComponents.host = "api.open-meteo.com"
        urlComponents.path = "/v1/forecast"
        
        urlComponents.queryItems = [
            URLQueryItem(
                name: "latitude",
                value: String(latitude)
            ),
            
            URLQueryItem(
                name: "longitude",
                value: String(longitude)
            ),
            
            URLQueryItem(
                name: "current",
                value: "temperature_2m,weather_code,wind_speed_10m"
            ),
            
            URLQueryItem(
                name: "temperature_unit",
                value: "fahrenheit"
            ),
            
            URLQueryItem(
                name: "wind_speed_unit",
                value: "mph"
            )
        ]
        
        // CREATE THE FINAL URL
        
        guard let url: URL = urlComponents.url else {
            throw WeatherError.invalidURL
        }
        
        // USE URLSESSION TO CALL THE WEATHER API
        
        let (data, response) = try await URLSession.shared.data(
            from: url
        )
        
        // MAKE SURE THE API RETURNED A SUCCESSFUL RESPONSE
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            
            throw WeatherError.invalidResponse
        }
        
        // DECODE THE JSON DATA
        
        do {
            let weatherResponse = try JSONDecoder().decode(
                WeatherResponse.self,
                from: data
            )
            
            return weatherResponse.current
            
        } catch {
            throw WeatherError.decodingError
        }
    }
}
