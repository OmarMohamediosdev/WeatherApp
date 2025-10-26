//
//  CityListViewModelTests.swift
//  Weather AppTests
//
//  Created by Omar Mohamed on 27/10/2025.
//

import Foundation
import XCTest
@testable import Weather_App

final class CityListViewModelTests: XCTestCase {
    func test_loadAllCities_fetchesWeatherForEachCity() async {
        // Arrange
        let mockService = MockWeatherService()
        let viewModel = CityListViewModel(service: mockService)
        viewModel.cityNames = ["London", "Paris"]

        // Act
        await MainActor.run {
            viewModel.loadAllCities()
        }

        // Assert
        XCTAssertTrue(mockService.fetchWeatherCalled)
        XCTAssertEqual(viewModel.cityWeathers.count, 2)
    }

    func test_addCity_addsAndFetchesWeather() {
        let mockService = MockWeatherService()
        let viewModel = CityListViewModel(service: mockService)

        viewModel.addCity(named: "Berlin")

        XCTAssertTrue(mockService.fetchWeatherCalled)
        XCTAssertTrue(viewModel.cityNames.contains("Berlin"))
    }

    func test_addCity_preventsDuplicate() {
        let mockService = MockWeatherService()
        let viewModel = CityListViewModel(service: mockService)

        viewModel.cityNames = ["Vienna"]
        viewModel.addCity(named: "vienna")

        XCTAssertEqual(viewModel.errorMessage, "vienna is already in your list.")
    }
}
