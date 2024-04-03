//
//  WeatherViewTests.swift
//  WeatherAppTests
//
//  Created by Mats Trovik on 01/04/2024.
//

import SnapshotTesting
import SwiftUI
@testable import WeatherApp
import XCTest

final class WeatherViewTests: XCTestCase {
    func testEmpty() throws {
        let viewModel = WeatherViewModel(state: .empty, geoLookup: MockGeocoder(), dispatcher: MockDispatcher())
        let view = WeatherView(viewModel: viewModel)
        let host = UIHostingController(rootView: view)
        host.overrideUserInterfaceStyle = .light
        assertSnapshot(of: host, as: .image)
    }

    func testErrorGeocoding() throws {
        let viewModel = WeatherViewModel(state: .error(error: .geoLookupIssue), geoLookup: MockGeocoder(), dispatcher: MockDispatcher())
        let view = WeatherView(viewModel: viewModel)
        let host = UIHostingController(rootView: view)
        host.overrideUserInterfaceStyle = .light
        assertSnapshot(of: host, as: .image)
    }

    func testErrorForecast() throws {
        let viewModel = WeatherViewModel(state: .error(error: .forecastIssue), geoLookup: MockGeocoder(), dispatcher: MockDispatcher())
        let view = WeatherView(viewModel: viewModel)
        let host = UIHostingController(rootView: view)
        host.overrideUserInterfaceStyle = .light
        assertSnapshot(of: host, as: .image)
    }

    func testLoading() throws {
        let viewModel = WeatherViewModel(state: .loading, geoLookup: MockGeocoder(), dispatcher: MockDispatcher())
        let view = WeatherView(viewModel: viewModel)
        let host = UIHostingController(rootView: view)
        host.overrideUserInterfaceStyle = .light
        assertSnapshot(of: host, as: .image)
    }

    func testFullForecast() throws {
        let forecast = Forecast.fixture(type: .full)
        let viewModel = WeatherViewModel(state: .available(forecast: forecast), geoLookup: MockGeocoder(), dispatcher: MockDispatcher())
        let view = WeatherView(viewModel: viewModel)
        let host = UIHostingController(rootView: view)
        host.overrideUserInterfaceStyle = .light
        assertSnapshot(of: host, as: .image)
    }
}
