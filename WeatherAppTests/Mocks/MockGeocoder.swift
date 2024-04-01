//
//  MockGeocoder.swift
//  WeatherAppTests
//
//  Created by Mats Trovik on 29/03/2024.
//

import Foundation
@testable import WeatherApp

class MockGeocoder: Geocoder {
    var coordinate: (lat: Double, lon: Double)?
    var findLocationcalledForAddress: String?
    func findLocationForAddress(_ address: String) async -> (latitude: Double?, longitude: Double?) {
        findLocationcalledForAddress = address
        return (coordinate?.lat, coordinate?.lon)
    }
}
