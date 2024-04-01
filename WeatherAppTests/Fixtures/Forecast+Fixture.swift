//
//  Forecast+Fixture.swift
//  WeatherAppTests
//
//  Created by Mats Trovik on 01/04/2024.
//

import Foundation
@testable import WeatherApp

extension Forecast {
    enum ForecastFixtureType: String {
        case minimal = "MinimalData"
        case full = "FullData"
    }

    static func fixture(type: ForecastFixtureType = .minimal) -> Forecast {
        let data = forecastData(type: type)
        let parser = JSONDecoder()
        parser.dateDecodingStrategy = .iso8601
        return try! parser.decode(Forecast.self, from: data)
    }

    static func forecastData(type: ForecastFixtureType = .minimal) -> Data {
        let dataUrl = Bundle(for: ForecastTests.self).url(forResource: type.rawValue, withExtension: "json")!
        return try! Data(contentsOf: dataUrl)
    }
}
