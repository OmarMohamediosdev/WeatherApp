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

// MARK: - MockWeatherService (for previews/testing)
#if DEBUG
final class MockWeatherService: WeatherServiceProtocol {
    func fetchWeather(for city: String, completion: @escaping (Result<CityCurrentWeather, Error>) -> Void) {
        let mock = CityCurrentWeather(
            coord: Coord(lon: 0, lat: 0),
            weather: [Weather(id: 1, main: "Clear", description: "clear sky", icon: "01d")],
            base: nil,
            main: Main(temp: 293.15, feelsLike: 293.15, tempMin: 291.15, tempMax: 295.15,
                       pressure: 1012, humidity: 60, seaLevel: nil, grndLevel: nil),
            visibility: nil,
            wind: Wind(speed: 3.4, deg: 270),
            clouds: Clouds(all: 0),
            dt: Int(Date().timeIntervalSince1970),
            sys: Sys(type: nil, id: nil, country: "GB", sunrise: nil, sunset: nil),
            timezone: nil,
            id: 1234,
            name: "London",
            cod: 200
        )
        completion(.success(mock))
    }
}
#endif
