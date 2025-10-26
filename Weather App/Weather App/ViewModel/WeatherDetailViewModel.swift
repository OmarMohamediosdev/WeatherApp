//
//  WeatherDetailViewModel.swift
//  Weather App
//
//  Created by Omar Mohamed on 26/10/2025.
//

import Foundation
import Combine
import UIKit

final class WeatherDetailViewModel: ObservableObject {
    private let service: WeatherServiceProtocol
    let cityName: String
    let isHistory: Bool
    
    @Published var weather: CityCurrentWeather?
    @Published var weatherImage: UIImage?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init(cityName: String, service: WeatherServiceProtocol) {
        self.cityName = cityName
        self.service = service
        self.isHistory = false
    }
    
    // initializer for offline record
    init(record: WeatherInfo, service: WeatherServiceProtocol) {
        self.cityName = record.cityName ?? ""
        self.service = service
        self.isHistory = true // important: prevent auto-refresh
        
        // 🔥 Build CityCurrentWeather from record (readonly snapshot)
        self.weather = CityCurrentWeather(
            coord: nil,
            weather: [ Weather(id: nil,
                               main: record.condition,
                               description: record.condition,
                               icon: record.iconCode) ],
            base: nil,
            main: Main(temp: record.temperature,
                       feelsLike: nil, tempMin: nil, tempMax: nil,
                       pressure: nil, humidity: nil, seaLevel: nil, grndLevel: nil),
            visibility: nil,
            wind: nil,
            clouds: nil,
            dt: Int(record.timestamp?.timeIntervalSince1970 ?? Date().timeIntervalSince1970),
            sys: nil,
            timezone: nil,
            id: nil,
            name: record.cityName,
            cod: nil
        )
        
        if let icon = record.iconCode {
            fetchWeatherIcon(icon)
        }
    }
    
    func loadWeather() {
        guard !isHistory else { return }
        
        isLoading = true
        errorMessage = nil
        weather = nil
        weatherImage = nil
        
        service.fetchWeather(for: cityName) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    self.weather = data
                    if let iconCode = data.weather?.first?.icon {
                        self.fetchWeatherIcon(iconCode)
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    private func fetchWeatherIcon(_ code: String) {
        service.fetchWeatherIcon(for: code) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.weatherImage = image
                case .failure:
                    break // fallback silently
                }
            }
        }
    }
}
