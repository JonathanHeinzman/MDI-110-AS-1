//
//  LocationReadyView.swift
//  Location
//
//  Created by Jonathan Heinzman on 7/25/26.
//

import SwiftUI

struct LocationReadyView: View {
    
    let latText: String
    let longText: String
    let onRefresh: () -> Void
    let onSave: () -> Void
    
    
    
    var body: some View {
        VStack(spacing: 20){
            Text("Latitude: \(latText)")
            Text("Longitude: \(longText)")
            
            HStack(spacing: 50){
                Button("Refresh") {
                    self.onRefresh()
                }
                
                Button("Save check-in") {
                    self.onSave()
                    
                }.buttonStyle(.borderedProminent)
            }
            
        }
    }
}


#Preview {
    LocationReadyView(
        latText: "32.11", longText: "102.33", onRefresh: {}) {
            
        }

    
}
