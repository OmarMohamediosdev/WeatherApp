//
//  WeatherDetailViewModel.swift
//  Weather App
//
//  Created by Omar Mohamed on 26/10/2025.
//

import Foundation
import Combine

final class WeatherDetailViewModel: ObservableObject {
    private let service: WeatherServiceProtocol
    let cityName: String
    
    @Published var weather: CityCurrentWeather?
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
        
        service.fetchWeather(for: cityName) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    self.weather = data
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
