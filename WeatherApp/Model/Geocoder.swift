//
//  Geocoder.swift
//  WeatherApp
//
//  Created by Mats Trovik on 29/03/2024.
//

import Foundation

protocol Geocoder {
    func findLocationForAddress(_ address: String) async -> (latitude: Double?, longitude: Double?) 
}
