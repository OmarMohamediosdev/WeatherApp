//
//  WeatherServiceMock.swift
//  Weather AppTests
//
//  Created by Omar Mohamed on 26/10/2025.
//

import Foundation
import Weather_App

final class MockWeatherService: WeatherServiceProtocol {
    var shouldReturnError = false
    var fetchWeatherCalled = false
    var fetchIconCalled = false
    
    var mockWeather: CityCurrentWeather = CityCurrentWeather(
        coord: Coord(lon: 10.0, lat: 20.0),
        weather: [Weather(id: 1, main: "Clear", description: "clear sky", icon: "01d")],
        base: "stations",
        main: Main(temp: 293.15, feelsLike: 293.15, tempMin: 292.0, tempMax: 294.0,
                   pressure: 1000, humidity: 50, seaLevel: nil, grndLevel: nil),
        visibility: 10000,
        wind: Wind(speed: 3.5, deg: 270),
        clouds: Clouds(all: 0),
        dt: Int(Date().timeIntervalSince1970),
        sys: Sys(type: nil, id: nil, country: "GB", sunrise: nil, sunset: nil),
        timezone: 0,
        id: 123,
        name: "London",
        cod: 200
    )
    
    func fetchWeather(for city: String, completion: @escaping (Result<CityCurrentWeather, Error>) -> Void) {
        fetchWeatherCalled = true
        if shouldReturnError {
            completion(.failure(NSError(domain: "TestError", code: -1)))
        } else {
            completion(.success(mockWeather))
        }
    }
    
    func fetchWeatherIcon(for iconCode: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        fetchIconCalled = true
        if shouldReturnError {
            completion(.failure(NSError(domain: "IconError", code: -1)))
        } else {
            let image = UIImage(systemName: "sun.max") ?? UIImage()
            completion(.success(image))
        }
    }
}
