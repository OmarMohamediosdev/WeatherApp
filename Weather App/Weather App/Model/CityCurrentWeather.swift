//
//  WeatherResponse.swift
//  Weather App
//
//  Created by Omar Mohamed on 25/10/2025.
//

import Foundation

// MARK: - CityCurrentWeather
nonisolated struct CityCurrentWeather: Codable, Identifiable {
    let coord: Coord?
    let weather: [Weather]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let timezone, id: Int?
    let name: String?
    let cod: Int?
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int?
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double?
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, humidity, seaLevel, grndLevel: Int?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let type, id: Int?
    let country: String?
    let sunrise, sunset: Int?
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int?
    let main, description, icon: String?
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double?
    let deg: Int?
}


let mockWeather = CityCurrentWeather(
    coord: Coord(lon: 16.37, lat: 48.21),
    weather: [Weather(id: 1, main: "Clouds", description: "few clouds", icon: "02d")],
    base: nil,
    main: Main(temp: 295.15, feelsLike: 295.15, tempMin: 293.15, tempMax: 297.15,
               pressure: 1013, humidity: 65, seaLevel: nil, grndLevel: nil),
    visibility: nil,
    wind: Wind(speed: 3.5, deg: 250),
    clouds: Clouds(all: 20),
    dt: Int(Date().timeIntervalSince1970),
    sys: Sys(type: nil, id: nil, country: "AT", sunrise: nil, sunset: nil),
    timezone: 7200,
    id: 1,
    name: "Vienna",
    cod: 200
)
