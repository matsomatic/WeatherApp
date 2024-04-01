//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Mats Trovik on 29/03/2024.
//

@testable import WeatherApp
import XCTest

final class ForecastTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testParsing() throws {
        let dataUrl = Bundle.main.url(forResource: "DummyData", withExtension: "json")!
        let data = try Data(contentsOf: dataUrl)
        let parser = JSONDecoder()
        parser.dateDecodingStrategy = .iso8601
        let result = try parser.decode(Forecast.self, from: data)
        print(result)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
