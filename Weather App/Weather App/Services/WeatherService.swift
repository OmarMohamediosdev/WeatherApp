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
    func fetchWeatherIcon(for iconCode: String, completion: @escaping (Result<UIImage, Error>) -> Void)
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
    
    func fetchWeatherIcon(for iconCode: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let iconURL = "https://openweathermap.org/img/wn/\(iconCode)@2x.png"
        
        AF.request(iconURL).responseData { response in
            switch response.result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    completion(.success(image))
                } else {
                    completion(.failure(NSError(domain: "InvalidImage", code: 0)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
