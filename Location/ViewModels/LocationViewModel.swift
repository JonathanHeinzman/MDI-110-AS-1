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
    
    
    // CALL OUR SERVICE
    var locationService: LocationService = LocationService()
    
    
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
            
            return
        }
        
        self.errorMessage = "No location"
        self.currentViewState = .failed
        
    }
    
    
    func saveCheckInsButton() {
        if self.locationService.location == nil {return}
        
        let coordinate: CLLocationCoordinate2D = self.locationService.location!
        
        let newCoord: CheckIN = CheckIN(latitude: coordinate.latitude, longitude: coordinate.longitude)
    
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
    
    
    
    
    
}

    
    
    
    

