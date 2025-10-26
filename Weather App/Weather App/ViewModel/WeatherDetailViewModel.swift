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
    
    @Published var weather: CityCurrentWeather?
    @Published var weatherImage: UIImage?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init(cityName: String, service: WeatherServiceProtocol) {
        self.cityName = cityName
        self.service = service
    }
    
    func loadWeather() {
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
