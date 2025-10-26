//
//  CityListViewModel.swift
//  Weather App
//
//  Created by Omar Mohamed on 26/10/2025.
//

import SwiftUI
import Combine
import CoreData

@MainActor
final class CityListViewModel: ObservableObject {
    // MARK: - Dependencies
    private let service: WeatherServiceProtocol
    
    // MARK: - Published properties (UI state)
    @Published var cityNames: [String] = ["London", "Vienna", "Paris"]
    @Published var cityWeathers: [CityCurrentWeather] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // MARK: - Init (Dependency Injection)
    init(service: WeatherServiceProtocol) {
        self.service = service
    }
    
    // MARK: - Actions
    func loadAllCities() {
        isLoading = true
        errorMessage = nil
        cityWeathers.removeAll()
        
        Task {
            for city in cityNames {
                await fetchWeather(for: city)
            }
            isLoading = false
        }
    }
    
    func addCity(named name: String) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        guard !cityNames.contains(where: { $0.lowercased() == trimmed.lowercased() }) else {
            errorMessage = "\(trimmed) is already in your list."
            return
        }
        
        isLoading = true
        service.fetchWeather(for: trimmed) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let weather):
                    self.cityNames.append(trimmed)
                    self.cityWeathers.append(weather)
                    self.saveWeatherHistory(for: weather)
                case .failure:
                    self.errorMessage = "Couldn't find weather data for '\(trimmed)'. Please check the spelling."
                }
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        cityNames.remove(atOffsets: offsets)
        cityWeathers.remove(atOffsets: offsets)
    }
    
    private func fetchWeather(for city: String) async {
        await withCheckedContinuation { continuation in
            service.fetchWeather(for: city) { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success(let weather):
                        self.cityWeathers.append(weather)
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                    }
                    continuation.resume()
                }
            }
        }
    }
    
    // persist weather history
    private func saveWeatherHistory(for weather: CityCurrentWeather) {
        let context = PersistenceController.shared.container.viewContext
        let record = WeatherInfo(context: context)
        record.cityName = weather.name ?? "Unknown"
        record.temperature = weather.main?.temp ?? 0
        record.condition = weather.weather?.first?.description ?? "Unknown"
        record.timestamp = Date()
        do {
            try context.save()
        } catch {
            print("Failed to save history: \(error)")
        }
    }
}
