//
//  WeatherService.swift
//  Weather App
//
//  Created by Omar Mohamed on 25/10/2025.
//

import Foundation
import Alamofire

// MARK: - WeatherServiceProtocol
protocol WeatherServiceProtocol {
    func fetchWeather(for city: String, completion: @escaping (Result<CityCurrentWeather, Error>) -> Void)
}

final class WeatherService: WeatherServiceProtocol {
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    private let apiKey = "f5cb0b965ea1564c50c6f1b74534d823"
    
    func fetchWeather(for city: String, completion: @escaping (Result<CityCurrentWeather, Error>) -> Void) {
        let params: [String: Any] = [
            "q": city,
            "appid": apiKey
        ]
        
        AF.request(baseURL, parameters: params)
            .validate()
            .responseDecodable(of: CityCurrentWeather.self) { response in
                switch response.result {
                case .success(let weather):
                    completion(.success(weather))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
