//
//  CityHistoryViewModel.swift
//  Weather App
//
//  Created by Omar Mohamed on 26/10/2025.
//

import SwiftUI
import CoreData
import UIKit
import Combine

@MainActor
final class CityHistoryViewModel: ObservableObject {
    private let service: WeatherServiceProtocol
    
    // 🔥 icon cache to avoid re-downloading
    @Published var iconImages: [String: UIImage] = [:]
    
    init(service: WeatherServiceProtocol) {
        self.service = service
    }
    
    // 🔥 fetch icon image for a specific code
    func fetchIcon(for code: String) {
        // avoid reloading if cached
        if iconImages[code] != nil { return }
        
        service.fetchWeatherIcon(for: code) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if case .success(let image) = result {
                    self.iconImages[code] = image
                }
            }
        }
    }
}
