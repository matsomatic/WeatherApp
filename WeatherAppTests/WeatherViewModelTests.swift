//
//  WeatherViewModelTests.swift
//  WeatherAppTests
//
//  Created by Mats Trovik on 01/04/2024.
//

import InlineSnapshotTesting
@testable import WeatherApp
import XCTest

final class WeatherViewModelTests: XCTestCase {
    var geocoder: MockGeocoder!
    var dispatcher: MockDispatcher!
    var sut: WeatherViewModel!
    
    override func setUp() {
        geocoder = MockGeocoder()
        dispatcher = MockDispatcher()
        sut = WeatherViewModel(geoLookup: geocoder, dispatcher: dispatcher)
    }
    
    func testLoadingState() throws {
        sut.performSearch()
        if case .loading = sut.state {
            XCTAssert(true)
        } else {
            XCTAssert(false, "Unexpected search error")
        }
    }
    
    func testGeocoderFailure() throws {
        // Setup
        geocoder.coordinate = nil
        sut.searchString = "London"
        
        // Configure expectation
        let expectation = XCTestExpectation(description: "Should Receive Error")
        @Sendable func observe() {
            withObservationTracking {
                if case .error = sut.state {
                    expectation.fulfill()
                }
            } onChange: {
                DispatchQueue.main.async(execute: observe)
            }
        }
        observe()
        
        // Execute test
        sut.performSearch()
        wait(for: [expectation], timeout: 1)
        
        // Verify
        XCTAssertEqual(geocoder.findLocationcalledForAddress, "London")
        
        let state = sut.state
        if case .error(let error) = state {
            XCTAssertEqual(error, .geoLookupIssue)
        } else {
            XCTAssert(false, "Unexpected search error")
        }
    }
    
    func testForecastFailure() throws {
        // Setup
        geocoder.coordinate = (1.0, 1.0)
        sut.searchString = "London"
        
        // Configure expectation
        let expectation = XCTestExpectation(description: "Should Receive Error")
        @Sendable func observe() {
            withObservationTracking {
                if case .error = sut.state {
                    expectation.fulfill()
                }
            } onChange: {
                DispatchQueue.main.async(execute: observe)
            }
        }
        observe()
        
        // Execute test
        sut.performSearch()
        wait(for: [expectation], timeout: 1)
        
        // Verify
        XCTAssertEqual(geocoder.findLocationcalledForAddress, "London")
        assertInlineSnapshot(of: dispatcher.dispatchedRequest?.params, as: .dump) {
            """
            ▿ Optional<Dictionary<String, String>>
              ▿ some: 5 key/value pairs
                ▿ (2 elements)
                  - key: "daily"
                  - value: "sunrise,sunset"
                ▿ (2 elements)
                  - key: "hourly"
                  - value: "temperature_2m,weather_code,wind_speed_10m,wind_direction_10m"
                ▿ (2 elements)
                  - key: "latitude"
                  - value: "1.0"
                ▿ (2 elements)
                  - key: "longitude"
                  - value: "1.0"
                ▿ (2 elements)
                  - key: "timezone"
                  - value: "auto"
            
            """
        }
        
        let state = sut.state
        if case .error(let error) = state {
            XCTAssertEqual(error, .forecastIssue)
        } else {
            XCTAssert(false, "Unexpected search error")
        }
    }

    func testForecastSuccess() throws {
        // Setup
        geocoder.coordinate = (1.0, 1.0)
        dispatcher.result = .success(Forecast.forecastData())
        sut.searchString = "London"
        
        // Configure expectation
        let expectation = XCTestExpectation(description: "Should Receive Error")
        @Sendable func observe() {
            withObservationTracking {
                if case .available = sut.state {
                    expectation.fulfill()
                }
            } onChange: {
                DispatchQueue.main.async(execute: observe)
            }
        }
        observe()
        
        // Execute test
        sut.performSearch()
        wait(for: [expectation], timeout: 1)
        
        // Verify
        XCTAssertEqual(geocoder.findLocationcalledForAddress, "London")
        assertInlineSnapshot(of: dispatcher.dispatchedRequest?.params, as: .dump) {
            """
            ▿ Optional<Dictionary<String, String>>
              ▿ some: 5 key/value pairs
                ▿ (2 elements)
                  - key: "daily"
                  - value: "sunrise,sunset"
                ▿ (2 elements)
                  - key: "hourly"
                  - value: "temperature_2m,weather_code,wind_speed_10m,wind_direction_10m"
                ▿ (2 elements)
                  - key: "latitude"
                  - value: "1.0"
                ▿ (2 elements)
                  - key: "longitude"
                  - value: "1.0"
                ▿ (2 elements)
                  - key: "timezone"
                  - value: "auto"
            
            """
        }
        
        let state = sut.state
        if case .available(let forecast) = state {
            assertInlineSnapshot(of: forecast, as: .dump) {
                """
                ▿ Forecast
                  ▿ dailyData: 2 elements
                    ▿ DailyData
                      - day: 2024-03-29T00:00:00Z
                      ▿ hourlyData: 1 element
                        ▿ HourlyData
                          - temperature: 30.0
                          - time: 2024-03-29T12:00:00Z
                          - weatherCode: WeatherCode.overcast
                          - windDirection: 335
                          - windSpeed: 6.0
                      - sunrise: 2024-03-29T06:05:00Z
                      - sunset: 2024-03-29T18:21:00Z
                    ▿ DailyData
                      - day: 2024-03-30T00:00:00Z
                      ▿ hourlyData: 1 element
                        ▿ HourlyData
                          - temperature: 25.0
                          - time: 2024-03-31T12:00:00Z
                          - weatherCode: WeatherCode.partlyCloudy
                          - windDirection: 45
                          - windSpeed: 7.0
                      - sunrise: 2024-03-30T06:04:00Z
                      - sunset: 2024-03-30T18:22:00Z
                  ▿ hourlyUnits: Units
                    - temperature: "°C"
                    - windSpeed: "km/h"
                  - timezoneAbbreviation: "EST"

                """
            }
        } else {
            XCTAssert(false, "Unexpected state")
        }
    }
}
