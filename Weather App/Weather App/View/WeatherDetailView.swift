//
//  WeatherDetailView.swift
//  Weather App
//
//  Created by Omar Mohamed on 25/10/2025.
//

import SwiftUI

struct WeatherDetailView: View {
    @StateObject private var viewModel: WeatherDetailViewModel
    @Environment(\.presentationMode) var presentationMode
    
    init(cityWeather: CityCurrentWeather, service: WeatherServiceProtocol = WeatherService()) {
        _viewModel = StateObject(
            wrappedValue: WeatherDetailViewModel(cityName: cityWeather.name ?? "", service: service)
        )
    }
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    VStack {
                        ProgressView("Loading weather for \(viewModel.cityName)...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                        Spacer()
                    }
                } else if let error = viewModel.errorMessage {
                    VStack(spacing: 16) {
                        Text("⚠️ Error")
                            .font(.title2)
                        Text(error)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                        Button("Retry") {
                            viewModel.loadWeather()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                } else if let weather = viewModel.weather {
                    ScrollView {
                        VStack(spacing: 16) {
                            Text(weather.name ?? "")
                                .font(.largeTitle)
                                .bold()
                            
                            // add weather icon
                            if let image = viewModel.weatherImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .shadow(radius: 6)
                                    .padding(.top, 8)
                            }
                            
                            if let kelvin = weather.main?.temp {
                                Text(String(format: "%.1f ℃", kelvin - 273.15))
                                    .font(.system(size: 48, weight: .semibold))
                            }
                            
                            if let desc = weather.weather?.first?.description {
                                Text(desc.capitalized)
                                    .font(.title3)
                                    .foregroundColor(.secondary)
                            }
                            
                            Divider().padding(.vertical, 10)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Humidity: \(weather.main?.humidity ?? 0)%", systemImage: "drop.fill")
                                Label("Wind speed: \(weather.wind?.speed ?? 0, specifier: "%.1f") m/s", systemImage: "wind")
                                
                                if let pressure = weather.main?.pressure {
                                    Label("Pressure: \(pressure) hPa", systemImage: "gauge")
                                }
                                
                                if let dt = weather.dt {
                                    let date = Date(timeIntervalSince1970: TimeInterval(dt))
                                    Label("Last updated: \(date.formatted(date: .abbreviated, time: .shortened))", systemImage: "clock")
                                }
                            }
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Spacer()
                        }
                        .padding()
                    }
                } else {
                    VStack {
                        Text("No data available")
                            .foregroundColor(.secondary)
                        Button("Retry") { viewModel.loadWeather() }
                    }
                    .padding()
                }
            }
            .navigationTitle(viewModel.cityName)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { presentationMode.wrappedValue.dismiss() }
                }
            }
            .onAppear {
                viewModel.loadWeather()
            }
        }
    }
}

#Preview {
    WeatherDetailView(cityWeather: mockWeather)
}
