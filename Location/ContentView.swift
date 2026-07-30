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
        ScrollView {
            VStack(spacing: 20) {
                
                Text("Nearby-Logs")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                
                Group {
                    Text("Current Location")
                        .font(.title2)
                    if viewModel.currentViewState == .needsPermission {
                        
                        PermissionView(
                            onEnable: {
                                viewModel.enableLocationButton()
                            }
                        )
                        
                    } else if viewModel.currentViewState == .loading {
                        
                        LoadingView()
                        
                    } else if viewModel.currentViewState == .ready {
                        
                        VStack(spacing: 16) {
                            
                            LocationReadyView(
                                latText: viewModel.latText,
                                longText: viewModel.longText,
                                onRefresh: {
                                    viewModel.refreshButton()
                                },
                                onSave: {
                                    viewModel.saveCheckInsButton()
                                }
                            )
                            
                            WeatherCardView(
                                weather: viewModel.weather,
                                isLoading: viewModel.isWeatherLoading,
                                errorMessage: viewModel.weatherErrorMessage,
                                lastUpdated: viewModel.lastUpdated
                            )
                        }
                        
                    } else if viewModel.currentViewState == .failed {
                        
                        FailedView(
                            message: viewModel.errorMessage,
                            tryAgain: {
                                viewModel.enableLocationButton()
                            }
                        )
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                .cornerRadius(16)
                
                CheckInListView(
                    checkIn: viewModel.checkIns,
                    onClearAll: {
                        viewModel.clearAll()
                    }
                )
            }
            .padding()
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
            VStack(spacing: 12) {
                
                ProgressView()
                
                Text("Loading Location...")
                    .font(.headline)
                    .foregroundStyle(.blue)
            }
            .padding()
        }
    }
    
    struct CheckInListView: View {
        let checkIn: [CheckIN]
        let onClearAll: () -> Void
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                
                HStack {
                    Text("Check-Ins")
                        .font(.headline)
                    
                    Spacer()
                    
                    Button("Clear All") {
                        onClearAll()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(checkIn.isEmpty)
                }
                
                if checkIn.isEmpty {
                    
                    Text("No Check-Ins")
                        .foregroundStyle(.secondary)
                    
                } else {
                    
                    List(checkIn) { item in
                        
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(item.date, style: .date)
                                    .font(.headline)
                                
                                Spacer()
                                
                                Text(item.date, style: .time)
                                    .foregroundStyle(.secondary)
                                
                            }
                            
                            
                            Divider()
                            
                            Text("Latitude: \(String(format: "%.5f", item.latitude))")
                            
                            Text("Longitude: \(String(format: "%.5f", item.longitude))")
                            
                            Text("Weather: \(String(item.checkInWeather.temperature)) °F")
                        }
                        .padding(.vertical, 4)
                    }
                    .frame(height: 275)
                    .listStyle(.plain)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(16)
        }
    }
    
    struct WeatherCardView: View {
        
        let weather: CurrentWeather?
        let isLoading: Bool
        let errorMessage: String
        let lastUpdated: Date?
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                
                Text("Current Weather")
                    .font(.headline)
                
                if isLoading {
                    
                    HStack {
                        ProgressView()
                        
                        Text("Loading weather...")
                            .foregroundStyle(.secondary)
                    }
                    
                } else if !errorMessage.isEmpty {
                    
                    Text(errorMessage)
                        .foregroundStyle(.red)
                    
                } else if let weather {
                    
                    HStack {
                        
                        VStack(alignment: .leading, spacing: 6) {
                            
                            Text("\(weather.temperature, specifier: "%.0f")°F")
                                .font(.title)
                                .bold()
                            
                            Text(weather.condition.rawValue)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 6) {
                            
                            Image(systemName: "wind")
                                .font(.title2)
                            
                            Text("\(weather.windSpeed, specifier: "%.1f") mph")
                            
                            Text("Wind")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    if let lastUpdated {
                        Text("Updated \(lastUpdated, style: .time)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemGray6))
            .cornerRadius(16)
        }
    }
}
    
    
#Preview {
    ContentView()
}
