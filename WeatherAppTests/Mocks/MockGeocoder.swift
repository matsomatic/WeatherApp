//
//  MockGeocoder.swift
//  WeatherAppTests
//
//  Created by Mats Trovik on 29/03/2024.
//

import Foundation
@testable import WeatherApp

struct MockGeocoder: Geocoder {
    var coordinate: (lat: Double, lon: Double)?
    func findLocationForAddress(_ address: String) async -> (latitude: Double?, longitude: Double?) {
        return (coordinate?.lat, coordinate?.lon)
    }
}
