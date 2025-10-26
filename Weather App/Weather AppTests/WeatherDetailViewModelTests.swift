//
//  WeatherDetailViewModelTests.swift
//  Weather AppTests
//
//  Created by Omar Mohamed on 27/10/2025.
//

import Foundation
import XCTest
@testable import Weather_App

final class WeatherDetailViewModelTests: XCTestCase {
    func test_loadWeather_success() {
        let mockService = MockWeatherService()
        let viewModel = WeatherDetailViewModel(cityName: "London", service: mockService)

        viewModel.loadWeather()

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.weather)
        XCTAssertEqual(viewModel.weather?.name, "London")
    }

    func test_loadWeather_failure() {
        let mockService = MockWeatherService()
        mockService.shouldReturnError = true
        let viewModel = WeatherDetailViewModel(cityName: "London", service: mockService)

        viewModel.loadWeather()

        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertNil(viewModel.weather)
    }

    func test_init_withHistoryRecord_preloadsWeather() {
        let record = WeatherInfo(context: PersistenceController.shared.container.viewContext)
        record.cityName = "Rome"
        record.temperature = 290
        record.condition = "Cloudy"
        record.iconCode = "02d"
        record.timestamp = Date()

        let mockService = MockWeatherService()
        let vm = WeatherDetailViewModel(record: record, service: mockService)

        XCTAssertEqual(vm.cityName, "Rome")
        XCTAssertEqual(vm.weather?.name, "Rome")
        XCTAssertEqual(vm.weather?.weather?.first?.main, "Cloudy")
    }
}
