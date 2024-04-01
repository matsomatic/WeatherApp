//
//  WeatherCode+ImageTests.swift
//  WeatherAppTests
//
//  Created by Mats Trovik on 01/04/2024.
//

import XCTest
import SnapshotTesting
import SwiftUI
@testable import WeatherApp

final class WeatherCode_ImageTests: XCTestCase {

    func testAllImages() throws {
        let stack = VStack() {
            ForEach (WeatherCode.allCases, id: \.self) { code in
                HStack{
                    Text("\(code.rawValue): ")
                    code.image(night: false)
                    code.image(night: true)
                }
            }
        }
        let host = UIHostingController(rootView: stack)
        assertSnapshot(of: host, as: .image)
    }

}
