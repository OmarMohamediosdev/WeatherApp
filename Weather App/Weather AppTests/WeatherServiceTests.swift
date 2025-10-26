//
//  WeatherServiceTests.swift
//  Weather AppTests
//
//  Created by Omar Mohamed on 27/10/2025.
//

import Foundation
import XCTest
@testable import Weather_App

final class WeatherServiceTests: XCTestCase {
    func test_fetchWeather_success() {
        // Arrange
        let mockService = MockWeatherService()
        let expectation = XCTestExpectation(description: "Fetch weather success")

        // Act
        mockService.fetchWeather(for: "London") { result in
            switch result {
            case .success(let weather):
                XCTAssertEqual(weather.name, "London")
                XCTAssertEqual(weather.weather?.first?.main, "Clear")
            case .failure:
                XCTFail("Expected success, got failure")
            }
            expectation.fulfill()
        }

        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(mockService.fetchWeatherCalled)
    }

    func test_fetchWeather_failure() {
        let mockService = MockWeatherService()
        mockService.shouldReturnError = true
        let expectation = XCTestExpectation(description: "Fetch weather failure")

        mockService.fetchWeather(for: "Paris") { result in
            switch result {
            case .success:
                XCTFail("Expected failure")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}
