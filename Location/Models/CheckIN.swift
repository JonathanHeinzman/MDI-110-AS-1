//
//  CheckIN.swift
//  Location
//
//  Created by Jonathan Heinzman on 7/25/26.
//

// CREATE A MODEL FOR MY CHECKINS
import Foundation

struct CheckIN: Identifiable{
    
    let id: UUID
    let date: Date = Date()
    let latitude: Double
    let longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.id = UUID()
        self.latitude = latitude
        self.longitude = longitude
        
    }
}
 
