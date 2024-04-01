//
//  Color+TemperatureTests.swift
//  WeatherAppTests
//
//  Created by Mats Trovik on 01/04/2024.
//

import SnapshotTesting
import SwiftUI
@testable import WeatherApp
import XCTest

final class Color_TemperatureTests: XCTestCase {
    func testColorForTemepratures() {
        let stack = HStack {
            ForEach(-1 ..< 32, id: \.self) { degrees in
                let temperature = Double(degrees)
                Rectangle()
                    .fill(Color.temperatureColor(temperature: temperature))
                    .frame(width: 3, height: 10)
            }
        }
        let host = UIHostingController(rootView: stack)
        assertSnapshot(of: host, as: .image)
    }
}
