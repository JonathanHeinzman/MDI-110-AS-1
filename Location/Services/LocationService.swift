//
//  LocationService.swift
//  Location
//
//  Created by Jonathan Heinzman on 7/25/26.
//

import Foundation // <- Primitive types
import CoreLocation // Location API
import Combine

class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    
    // Create a manager (The real CoreLocation manager (APPLE API)
    private let manager: CLLocationManager = CLLocationManager()
    
    // SHARE LOCATION, ISLOADING AND PERMISSIONS
    // (X,Y) = (LATITUDE, LONGITUDE)
    @Published var location: CLLocationCoordinate2D?
    
    @Published var isLoading: Bool = false
    
    // Tracks current permission state (.notdetermines, .denied, .authorized, .etc)
    @Published var authStatus: CLAuthorizationStatus = .notDetermined
    
    
    // Overide
    override init() {
        
        // Overide the class CLLocationManagerDelegat
        super.init()
        
        manager.delegate = self
        
        // settings
        // A setting, set the accuracy for the sensor
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Sets the authStatus (the one the users sees)
        // The manager status (the one the app uses to allow the sensor to read location data)
        
        authStatus = manager.authorizationStatus
        
        
        
    }
    
    func requestLocation() {
        isLoading = true
        manager.requestLocation()
    }
    
    func requestPermissionAndLocation() {
        
        authStatus = manager.authorizationStatus
        
        
        if authStatus == .notDetermined {
            manager.requestWhenInUseAuthorization()
            return
        }
        
        if authStatus ==  .authorizedWhenInUse || authStatus ==  .authorizedAlways{
            requestLocation()
            return
        }
        
    }
    
    // MARK: TEMPLATE FUNCTIONS FROM CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // location = [(12,33),(111,33),(111,222)]
        
        if let lastLocation = locations.last {
           location = lastLocation.coordinate
        }
         
        isLoading = false
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        isLoading = false
    }
    
    
    // Function Overloading
    // When you create a function with the same namen, but the parameters are different
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        authStatus = manager.authorizationStatus
        
        if authStatus ==  .authorizedWhenInUse || authStatus ==  .authorizedAlways{
            requestLocation()
            
        }else {
            isLoading = false
        }
        
        
    }
    
    
}
