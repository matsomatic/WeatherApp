//
//  CLGeocoder+Geocoder.swift
//  WeatherApp
//
//  Created by Mats Trovik on 29/03/2024.
//

import Foundation
import CoreLocation

extension CLGeocoder: Geocoder {    
    func findLocationForAddress(_ address: String) async -> (latitude: Double?, longitude: Double?) {
        let result  = await withCheckedContinuation { continuation in
            
            geocodeAddressString(address) { placemarks, error in
                guard let placemark = placemarks?.first, let latitude = placemark.location?.coordinate.latitude, let longitude = placemark.location?.coordinate.longitude else {
                    let latitude: Double? = nil
                    let longitude: Double? = nil
                    continuation.resume(returning: (latitude: latitude, longitude: longitude))
                    return
                }
                continuation.resume(returning:(latitude: latitude, longitude: longitude))
            }
        }
        return result
    }
    
    
}
