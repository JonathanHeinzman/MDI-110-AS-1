//
//  LocationViewModel.swift
//  Location
//
//  Created by Jonathan Heinzman on 7/25/26.
//


// MARK: MDI 110: ASSIGNMENT 1: GLGeocoder() reverseGeocodeLocation()

import Foundation
import CoreLocation
import Combine


enum LocationViewState {
    case needsPermission
    case loading
    case ready
    case failed
    case denied
}


class LocationViewModel: ObservableObject {
    
    @Published var currentViewState: LocationViewState = .needsPermission
    
    @Published var latText: String = "--"
    @Published var longText: String = "--"
    
    @Published var errorMessage: String = ""
    @Published var checkIns: [CheckIN] = []
    
    // For Weather
    @Published var weather: CurrentWeather?
    @Published var weatherErrorMessage: String = ""
    @Published var isWeatherLoading: Bool = false
    @Published var lastUpdated: Date?
    
    // CALL OUR SERVICE
    var locationService: LocationService = LocationService()
    
    // CALL THE WEATHER SERVICE
    var weatherService: WeatherService = WeatherService()
    
    
    // CANCELLABLE -> Cancels processes
    var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    
    init () {
        // Observe the changes from location manager
        // Sensor -> LocationService -> ViewModel -> Views
        
        // MARK: Publisher and Subscriber pattern
        // Publisher = location Service -> Because this one has the data, and it updates the data every x amount of time
        // Subscriber = The one that waits for the change -> Change UI or update UI
        
        self.locationService.objectWillChange.sink {
            [weak self] in
            
            // UPDATE THE UI
            DispatchQueue.main.async {
            
                // IF THERE IS NEW DATA UPDATE THE UI
                if self != nil {
                    self!.updateUIFromManager() // THIS IS MY SUBSCRIBER
                }
                
            }
            
        }.store(in: &self.cancellable) // Stores or saves the current Subscriber to this Publisher
        
        self.updateUIFromManager()
        
    }
    
    
    
    func updateUIFromManager() {
        
        if self.locationService.isLoading == true {
            self.currentViewState = .loading
            return
        }
        
        let status: CLAuthorizationStatus = self.locationService.authStatus
        
        if status == .notDetermined {
            self.currentViewState = .needsPermission
            return
        }
        
        if status == .denied || status == .restricted {
            self.errorMessage = "Location access is off, enable it in settings"
            self.currentViewState = .denied
            return
        }
            
        if self.locationService.location != nil{
            
            let coordinate: CLLocationCoordinate2D = self.locationService.location!
            
            self.latText = String(format: "%.5f", coordinate.latitude)
            self.longText = String(format: "%.5f", coordinate.longitude)
            
            self.currentViewState = .ready
            
            // Weather for the current location
            
            Task{
                await self.fetchWeather(latitude: coordinate.latitude, longitude: coordinate.longitude)
            }
            
            return
        }
        
        self.errorMessage = "No location"
        self.currentViewState = .failed
        
    }
    
    
    func saveCheckInsButton() {
        if self.locationService.location == nil {return}
        
        if weather == nil {return}
        
        let coordinate: CLLocationCoordinate2D = self.locationService.location!
        
        let newCoord: CheckIN = CheckIN(latitude: coordinate.latitude, longitude: coordinate.longitude, checkInWeather: weather!)
    
        self.checkIns.insert(newCoord, at: 0)
        
        print("new coordinate added")
    }
    
    func clearAll() {
        self.checkIns.removeAll()
    }
    
    func enableLocationButton() {
        errorMessage = ""
        currentViewState = .loading
        locationService.requestPermissionAndLocation()
        
    }
    
    func refreshButton() {
        errorMessage = ""
        currentViewState = .loading
        locationService.requestPermissionAndLocation()
    }
    
    // function to fetch the weather
    func fetchWeather(

        latitude: Double,
        longitude: Double
    ) async {
        
        await MainActor.run {
            self.isWeatherLoading = true
            self.weatherErrorMessage = ""
        }
        
        do {
            let currentWeather: CurrentWeather =
                try await self.weatherService.fetchWeather(
                    latitude: latitude,
                    longitude: longitude
                )
            
            await MainActor.run {
                self.weather = currentWeather
                self.lastUpdated = Date()
                self.isWeatherLoading = false
            }
            
        } catch {
            await MainActor.run {
                self.weatherErrorMessage =
                    error.localizedDescription
                
                self.isWeatherLoading = false
            }
        }
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

    
    
    
    

