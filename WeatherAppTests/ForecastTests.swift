//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Mats Trovik on 29/03/2024.
//

import InlineSnapshotTesting
@testable import WeatherApp
import XCTest

final class ForecastTests: XCTestCase {
    func testParsing() throws {
        let dataUrl = Bundle(for: ForecastTests.self).url(forResource: "MinimalData", withExtension: "json")!
        let data = try Data(contentsOf: dataUrl)
        let parser = JSONDecoder()
        parser.dateDecodingStrategy = .iso8601
        let result = try parser.decode(Forecast.self, from: data)
        assertInlineSnapshot(of: result, as: .dump) {
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
    }
}
