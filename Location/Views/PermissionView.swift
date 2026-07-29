//
//  PermissionView.swift
//  Location
//
//  Created by Jonathan Heinzman on 7/25/26.
//

import SwiftUI

struct PermissionView: View {
    
    let onEnable: () -> Void
    
    var body: some View {
        VStack(spacing: 12){
            Text("We need the location to save the check-ins").bold().padding()
            
            Button("Enable location"){
                self.onEnable()
                
            }.buttonStyle(.borderedProminent)
                
        }
    }
}


#Preview {
    
    PermissionView(onEnable: {})
}
