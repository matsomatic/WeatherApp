//
//  MockGeocoder.swift
//  WeatherAppTests
//
//  Created by Mats Trovik on 29/03/2024.
//

import Foundation

struct MockGeocoder: Geocoder {
    func findLocationForAddress(_ address: String) async -> (latitude: Double?, longitude: Double?) {
        return (0.5,0.5)
    }
    
    
}
