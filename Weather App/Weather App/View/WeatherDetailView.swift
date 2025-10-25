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
        _viewModel = StateObject(wrappedValue: WeatherDetailViewModel(cityName: cityWeather.name ?? "", service: service))
    }
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let weather = viewModel.weather {
                    VStack(spacing: 16) {
                        Text(weather.name ?? "")
                            .font(.largeTitle)
                            .bold()
                        if let kelvin = weather.main?.temp {
                            Text(String(format: "%.1f ℃", kelvin - 273.15))
                                .font(.system(size: 48, weight: .semibold))
                        }
                        if let desc = weather.weather?.first?.description {
                            Text(desc.capitalized)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Humidity: \(weather.main?.humidity ?? 0)%", systemImage: "drop.fill")
                            Label("Wind speed: \(weather.wind?.speed ?? 0, specifier: "%.1f") m/s", systemImage: "wind")
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                    .padding()
                } else if let error = viewModel.errorMessage {
                    VStack(spacing: 16) {
                        Text("Error: \(error)")
                        Button("Retry") { viewModel.loadWeather() }
                    }
                }
            }
            .navigationTitle("Weather")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { presentationMode.wrappedValue.dismiss() }
                }
            }
            .onAppear { viewModel.loadWeather() }
        }
    }
}

#Preview {
    WeatherDetailView(cityWeather: mockWeather)
}
