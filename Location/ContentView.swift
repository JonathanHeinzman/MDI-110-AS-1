//
//  ContentView.swift
//  Location
//
//  Created by Jonathan Heinzman on 7/25/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: LocationViewModel = LocationViewModel()
    
    var body: some View {
        VStack {
            
            Text("Nearby-Logs").font(.title)
            
            if viewModel.currentViewState == .needsPermission {

                PermissionView(onEnable: {viewModel.enableLocationButton()})

            }else if viewModel.currentViewState == .loading {
                LoadingView()
                
            }else if viewModel.currentViewState == .ready {
                LocationReadyView(
                    latText: viewModel.latText,
                    longText: viewModel.longText,
                    onRefresh: {viewModel.refreshButton()},
                    onSave: {viewModel.saveCheckInsButton()}
                )
            }else if viewModel.currentViewState == .failed {
                FailedView(
                    message: viewModel.errorMessage,
                    tryAgain: {viewModel.enableLocationButton()}
                )
            }
            
            
            CheckInListView(
                checkIn: viewModel.checkIns,
                onClearAll: {viewModel.clearAll()}
            )
        }
        
    }
}



struct FailedView: View {
    
    let message: String
    let tryAgain: () -> Void
    
    var body: some View {
        Text(message).foregroundColor(.red).bold()
        
        Button("Try Again"){
            tryAgain()
        }
    }
}

struct LoadingView: View {
    var body: some View {
        VStack{
            Text("Loading location").bold().foregroundColor(.blue).padding()
            ProgressView().tint(.blue)
        }
        
    }
}

struct CheckInListView: View {
    let checkIn: [CheckIN]
    let onClearAll: () -> Void
    
    var body: some View {
        VStack{
            HStack{
                Text("Check-Ins").font(.headline).bold()
                
                Button("Clear All"){
                    onClearAll()
                }
                .disabled(checkIn.count == 0)
                .buttonStyle(.borderedProminent)
                
                
            }
                
            if checkIn.count == 0 {
                Text("No Check-Ins")
            } else {
                List(checkIn){ item in
                    
                    VStack(spacing: 12){
                        Text(item.date, style: .time)
                        Text(item.date, style: .date)
                        
                        
                        Text("Latitude: \(String(format:"%0.5f",item.latitude))")
                                                  
                        Text("Longitude: \(String(format:"%0.5f",item.longitude))")
                    }
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
